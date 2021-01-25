
// an empty statemachine only to use latent functions when the player presses the
// input to analyze the surrounding areas
statemachine class RER_EcosystemAnalyzer extends CEntity {
  var ecosystem_manager: RER_EcosystemManager;

  public function init(manager: RER_EcosystemManager) {
    this.ecosystem_manager = manager;
    
    this.GotoState('Waiting');

    theInput.RegisterListener(this, 'OnAnalyseEcosystem', 'EcosystemAnalyse');
  }

  event OnAnalyseEcosystem(action: SInputAction) {
    if (IsPressed(action) && this.GetCurrentStateName() != 'Analysing') {
      this.GotoState('Analysing');
    }
  }
}

state Waiting in RER_EcosystemAnalyzer {}

state Analysing in RER_EcosystemAnalyzer {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('RER', "RER_EcosystemAnalyzer - state ANALYSING");

    this.startAnalysing();
  }

  entry function startAnalysing() {
    REROL_mhm(true);

    this.playAnimation();

    Sleep(1.5);

    this.openBookPopup(
      this.getSurroundingCreaturesPercentages()
    );

    this.stopAnimation();

    parent.GotoState('Waiting');
  }

  latent function playRandomNothingOneliner() {
    if (RandRange(10) < 3) {
      REROL_nothing(true);
    }
    else if (RandRange(10) < 3) {
      REROL_nothing_here(true);
    }
    else {
      REROL_nothing_interesting(true);
    }
  }

  latent function playAnimation() {
		thePlayer.PlayerStartAction( PEA_ExamineGround, '' );
    // ActionPlaySlotAnimationAsync
  }

  latent function stopAnimation() {
    thePlayer.PlayerStopAction( PEA_ExamineGround );
  }

  function getSurroundingCreaturesPercentages(): array<RER_SurroundingCreaturePercentage> {
    var output: array<RER_SurroundingCreaturePercentage>;
    var modifiers: array<float>;
    var positive_total: float;
    var negative_total: float;
    var percent: float;
    var i: int;

    modifiers = parent.ecosystem_manager.getCreatureModifiersForEcosystemAreas(
      parent.ecosystem_manager.getCurrentEcosystemAreas()
    );

    // first we get the total
    for (i = 0; i < CreatureMAX; i += 1) {
      if (modifiers[i] > 0) {
        positive_total += modifiers[i];
      }
      else {
        // we want the total to also be positive
        negative_total += modifiers[i];
      }

      LogChannel('RER', "getSurroundingCreaturesPercentages - current modifier = " + modifiers[i]);
    }

    negative_total = AbsF(negative_total);

    // then for all creature with modifiers
    for (i = 0; i < CreatureMAX; i += 1) {
      if (modifiers[i] != 0) {
        if (modifiers[i] > 0) {
          percent = modifiers[i] / positive_total;
        }
        else {
          percent = modifiers[i] / negative_total;
        }

        LogChannel('RER', "getSurroundingCreaturesPercentages - percent for " + (CreatureType)i + " - " + percent);

        // only creatures whose percentage is above 5
        if (percent > 0.05 || percent < -0.05) {
          output.PushBack(newSurroundingCreaturePercentage(i,percent));
        }
      }
    }

    return output;
  }

  latent function openBookPopup(creatures: array<RER_SurroundingCreaturePercentage>) {
    var sorted_creatures_ascending: array<RER_SurroundingCreaturePercentage>;
    var picked_creature: RER_SurroundingCreaturePercentage;
    var popup_data: BookPopupFeedback;
    var id: SItemUniqueId;
    var message: string;
    var i: int;

    if (creatures.Size() == 0) {
      this.playRandomNothingOneliner();

      return;
    }

    sorted_creatures_ascending = this.sortCreaturePercentagesAscending(creatures);

    LogChannel('RER', "positive sorted creatures size " + sorted_creatures_ascending.Size());

    if (sorted_creatures_ascending.Size() == 0) {
      this.playRandomNothingOneliner();

      return;
    }

    message = "This area and its vicinity is teeming with ";

    if (sorted_creatures_ascending.Size() > 0) {
      picked_creature = sorted_creatures_ascending[sorted_creatures_ascending.Size() - 1];
      if (picked_creature.percentage > 0) {
        message += getCreatureNameFromCreatureType(
          parent.ecosystem_manager.master.bestiary,
          picked_creature.type
        );
      }
    }

    if (sorted_creatures_ascending.Size() > 1) {
      picked_creature = sorted_creatures_ascending[sorted_creatures_ascending.Size() - 2];
      if (picked_creature.percentage > 0) {
        message += " and " + getCreatureNameFromCreatureType(
          parent.ecosystem_manager.master.bestiary,
          picked_creature.type
        );
      }
    }
    

    if (sorted_creatures_ascending.Size() > 0) {
      picked_creature = sorted_creatures_ascending[0];

      if (picked_creature.percentage < 0) {
        message += ", which makes the possibility of encountering " + getCreatureNameFromCreatureType(
          parent.ecosystem_manager.master.bestiary,
          picked_creature.type
        );
      }

      if (sorted_creatures_ascending.Size() > 1) {
        picked_creature = sorted_creatures_ascending[1];
        message += " and " + getCreatureNameFromCreatureType(
          parent.ecosystem_manager.master.bestiary,
          picked_creature.type
        );
      }

      message += " unlikely.";
    }

    message += ".";

    if (sorted_creatures_ascending.Size() > 0) {
      picked_creature = sorted_creatures_ascending[sorted_creatures_ascending.Size() - 1];
      message += "<br /><br />" + this.getEcosystemAdvice(picked_creature.type);
    }

    // first the positive percentages
    // for (i = 0; i < creatures.Size(); i += 1) {
    //   if (i > 0) {
    //     message += ", ";
    //   }

    //   if (creatures[i].percentage > 0) {
    //     message += (int)(creatures[i].percentage * 100) + "% with " + getCreatureNameFromCreatureType(
    //       parent.ecosystem_manager.master.bestiary,
    //       i
    //     );
    //   }
    // }

    popup_data = new BookPopupFeedback in thePlayer;
    popup_data.SetMessageTitle( "Surrounding ecosystem" );
    popup_data.SetMessageText( message );
    popup_data.curInventory = thePlayer.GetInventory();
    popup_data.PauseGame = true;
    popup_data.bookItemId = id;
        
    theGame.RequestMenu('PopupMenu', popup_data);
  }

  function sortCreaturePercentagesAscending(percentages: array<RER_SurroundingCreaturePercentage>): array<RER_SurroundingCreaturePercentage> {
    var output: array<RER_SurroundingCreaturePercentage>;
    var sorted_percentages: array<float>;
    var sorted_size: int;
    var i, j: int;

    // first we fill the array with the percentages
    for (i = 0; i < percentages.Size(); i += 1) {
      sorted_percentages.PushBack(percentages[i].percentage);
    }

    // then we sort them
    ArraySortFloats(sorted_percentages);

    for (i = 0; i < percentages.Size(); i += 1) {
      LogChannel('RER', "sort positive, value" + sorted_percentages[i]);
    }

    sorted_size = sorted_percentages.Size();

    for (i = 0; i < percentages.Size(); i += 1) {
      for (j = sorted_size; j >= 0; j -= 1) {
        if (percentages[j].percentage == sorted_percentages[i] && percentages[j].type != CreatureNONE) {
          output.PushBack(percentages[j]);

          percentages[j].type = CreatureNONE;
        }
      }
    }

    for (i = 0; i < output.Size(); i += 1) {
      LogChannel('RER', "sort ascending, value" + output[i].type + " " + output[i].percentage);
    }

    return output;
  }

  function getEcosystemAdvice(main_creature_type: CreatureType): string {
    var advice: string;
    var creatures: array<CreatureType>;
    var i: int;

    advice = "A large community of " + getCreatureNameFromCreatureType(
      parent.ecosystem_manager.master.bestiary,
      main_creature_type
    ) + " lives here due to the abundance of ";

    // first we list the creatures who helped the community form in the area
    creatures = parent.ecosystem_manager.getCommunityReasonsToExist(main_creature_type);
    for (i = 0; i < creatures.Size(); i += 1) {
      // we stop after three creatures
      if (i == 3) {
        advice += " and such creatures";
        break;
      }

      // we add a quote for the second and third creature
      if (i > 0) {
        advice += ", ";
      }

      advice += getCreatureNameFromCreatureType(
        parent.ecosystem_manager.master.bestiary,
        creatures[i]
      );
    }

    // now we explain what we can find because of the wolves
    advice += ". Because of this other creatures like ";
    creatures = parent.ecosystem_manager.getCommunityGoodInfluences(main_creature_type);
    for (i = 0; i < creatures.Size(); i += 1) {
      // we stop after three creatures
      if (i == 3) {
        break;
      }

      // if it's the last creature in the list we add "and"
      if (i == creatures.Size() - 1 || i == 2) {
        advice += " and ";
      }
      // we add a quote for the second and third creature
      else if (i > 0) {
        advice += ", ";
      }

      advice += getCreatureNameFromCreatureType(
        parent.ecosystem_manager.master.bestiary,
        creatures[i]
      );
    }
    
    advice += " may live in the area.";

    // now we explain what would happen if the player killed wolves
    creatures = parent.ecosystem_manager.getCommunityBadInfluences(main_creature_type);

    if (creatures.Size() > 0) {
      // a small linebreak
      advice += "<br />";

      advice += getCreatureNameFromCreatureType(
        parent.ecosystem_manager.master.bestiary,
        main_creature_type
      ) + " also prevent ";

      creatures = parent.ecosystem_manager.getCommunityBadInfluences(main_creature_type);
      for (i = 0; i < creatures.Size(); i += 1) {
        // we stop after three creatures
        if (i == 3) {
          break;
        }

        // if it's the last creature in the list we add "and"
        if (i == creatures.Size() - 1 || i == 2) {
          advice += " and ";
        }
        // we add a quote for the second and third creature
        else if (i > 0) {
          advice += ", ";
        }

        advice += getCreatureNameFromCreatureType(
          parent.ecosystem_manager.master.bestiary,
          creatures[i]
        );
      }

      advice += " from living here.";
    }

    return advice;
  }
}

struct RER_SurroundingCreaturePercentage {
  var type: CreatureType;
  var percentage: float;
}

function newSurroundingCreaturePercentage(type: CreatureType, percentage: float): RER_SurroundingCreaturePercentage {
  var output: RER_SurroundingCreaturePercentage;

  output.type = type;
  output.percentage = percentage;

  return output;
}