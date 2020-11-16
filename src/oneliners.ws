
// Geralt: Died recently, wonder what killed it
// from "Mysterious Tracks" monster hunt.
// when interacting with a dead fiend.
latent function REROL_died_recently() {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests\generic_quests\no_mans_land\quest_files\mh107_fiend\scenes\mh107_geralts_oneliners.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "ClueDeadBies");

  Sleep(2.7); // Approved duration
}

// Geralt: Claw marks, bite marks… But no fire damage. Interesting.
latent function REROL_no_dragon() {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests\generic_quests\skellige\quest_files\mh208_forktail\scenes\mh208_geralt_oneliners.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "NoDragon");

  Sleep(5.270992); // Approved duration
}

// Geralt: Corpses… that's what drew the ghouls.
latent function REROL_what_drew_the_ghouls() {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests\minor_quests\no_mans_land\quest_files\mq1039_uninvited_guests\scenes\mq1039_geralt_oneliner.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "interaction");

  Sleep(2.933915); // Approved duration
}

// Geralt: So many corpses… And the war's just started.
latent function REROL_so_many_corpses() {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests\prologue\quest_files\q001_beggining\scenes\q001_0_geralt_comments.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "battlefield_comment");

  Sleep(3.502878); // Approved duration
}

// Geralt: Hm… Wonder where these clues'll lead me…
latent function REROL_wonder_clues_will_lead_me() {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests\generic_quests\novigrad\quest_files\mh307_minion\scenes\mh307_02_investigation.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "All_clues_in");

  Sleep(3.8); // Approved duration
}

// Geralt: What a shitty way to die
latent function REROL_shitty_way_to_die() {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests/part_2/quest_files/q106_tower/scenes_pickup/q106_14f_ppl_in_cages.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "Input");

  Sleep(2.6); // Approved duration
}

// Geralt: There you are...
latent function REROL_there_you_are() {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests/part_1/quest_files/q103_daughter/scenes/q103_08f_gameplay_geralt.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "spot_goat_in");

  Sleep(1.32); // Approved duration
}

// Geralt: That was tough...
latent function REROL_that_was_tough() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(321440, true);

  Sleep(1.155367); // Approved duration
}

// Geralt: Damn… Can't smell a thing. Must've lost the trail.
latent function REROL_cant_smell_a_thing() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(5399670, true);

  Sleep(1.155367); // Approved duration
}

// Geralt: Necrophages, great.
latent function REROL_necrophages_great(optional do_not_wait: bool) {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "dlc/dlc15/data/quests/quest_files/scenes/mq1058_geralt_oneliners.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "NecropphagesComment"); // no typo from me there, the two "p"

  if (!do_not_wait) {
    Sleep(2); // Approved duration
  }
}

// Geralt: The Wild Hunt.
latent function REROL_the_wild_hunt(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(539883, true);

  if (!do_not_wait) {
    Sleep(1.72); // Approved duration
  }
}

// Geralt: Go away or i'll kill you.
latent function REROL_go_or_ill_kill_you() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(476195, true);

  Sleep(2.684654); // Approved duration
}

// Geralt: Air's strange… Like dropping into a deep
// cellar on a hot day… And the mist…
latent function REROL_air_strange_and_the_mist(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1061986, true);

  if (!do_not_wait) {
    Sleep(6.6); // Approved duration
  }
}

// Geralt: Clawed and gnawed. Necrophages fed here… but all the wounds they inflicted are post-mortem.
latent function REROL_clawed_gnawed_not_necrophages() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(470573, true);

  Sleep(7.430004); // Approved duration
}

// Geralt: Wild Hunt killed them.
latent function REROL_wild_hunt_killed_them() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1047779, true);

  Sleep(2.36); // Approved duration
}

// Geralt: Should look around.
latent function REROL_should_look_around() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(397220, true);

  Sleep(1.390483); // Approved duration
}

// Geralt: Hm… Definitely came through here.
latent function REROL_came_through_here() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(382001, true);

  Sleep(2.915713); // Approved duration
}

// Geralt: Another victim.
latent function REROL_another_victim() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1002812, true);

  Sleep(1.390316); // Approved duration
}

// Geralt: Miles and miles and miles…
latent function REROL_miles_and_miles_and_miles() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1077634, true);

  Sleep(2.68); // Approved duration
}

// Geralt: I'm gonna hand your head from my sadle
latent function REROL_hang_your_head_from_sadle() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  REROL_hang_your_head_from_sadle_sync();

  Sleep(4); // Approved duration
}
function REROL_hang_your_head_from_sadle_sync() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1192331, true);
}

// Geralt: Someone'll pay for this trophy. No doubt about it.
latent function REROL_someone_pay_for_trophy() {
  REROL_someone_pay_for_trophy_sync();

  Sleep(3); // Approved duration
}
function REROL_someone_pay_for_trophy_sync() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(426514, true);
}

// Geralt: Good size. Wonder if this piece of rot'll get me anything.
latent function REROL_good_size_wonder_if_someone_pay() {
  REROL_good_size_wonder_if_someone_pay_sync();

  Sleep(3.648103); // Approved duration
}
function REROL_good_size_wonder_if_someone_pay_sync() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(376063, true);
}

// Geralt: Ground's splattered with blood for a few feet around. A lot of it.
latent function REROL_ground_splattered_with_blood() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(433486, true);

  Sleep(4.238883); // Approved duration
}

// Geralt: Another trail.
latent function REROL_another_trail() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(382013, true);

  Sleep(3); // Approved duration
}

// Geralt: Monsters… Can feel 'em… Coming closer… They're everywhere.
latent function REROL_monsters_everywhere_feel_them_coming() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(506666, true);

  Sleep(5.902488); // Approved duration
}

// Geralt: Should scour the local notice boards. Someone might've posted a contract for whatever lives here.
latent function REROL_should_scour_noticeboards(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1206920, true);

  if (!do_not_wait) {
    Sleep(10); // Could not find Approved duration
  }
}

// Geralt choice: I'll take the contract.
latent function REROL_ill_take_the_contract() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1181938, true);

  Sleep(5); // Could not find Approved duration
}

// Geralt: Pretty unusual contract…
latent function REROL_unusual_contract() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1154439, true);

  Sleep(5); // Could not find Approved duration
}

// Geralt: All right, time I got to work. Where'll I find this monster?
latent function REROL_where_will_i_find_this_monster() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(551205, true);

  Sleep(3.900127); // Approved duration
}

// Geralt: I'll tend to the monster
latent function REROL_ill_tend_to_the_monster() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1014194, true);

  Sleep(1.773995); // Approved duration
}

// Geralt: I accept the challenge
latent function REROL_i_accept_the_challenge() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1005381, true);

  Sleep(1.93088); // Approved duration
}

// Geralt: Mhm…
latent function REROL_mhm() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1185176, true);

  Sleep(2); // could not find Approved duration
}

// Geralt: It's over.
latent function REROL_its_over() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(485943, true);

  Sleep(2); // could not find Approved duration
}

// Geralt: Mff… Smell of a rotting corpse. Blood spattered all around.
latent function REROL_smell_of_a_rotting_corpse(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(471806, true);

  if (!do_not_wait) {
    Sleep(4.861064); // Approved duration
  }
}

// Geralt: Tracks - a nekker… A big one.
latent function REROL_tracks_a_nekker(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1042065, true);

  if (!do_not_wait) {
    Sleep(3.444402); // Approved duration
  }
}

// Geralt: Ooh. More drowners.
latent function REROL_more_drowners(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1002915, true);

  if (!do_not_wait) {
    Sleep(2.397404); // Approved duration
  }
}

// Geralt: Ghouls… And where there's ghouls… there's usually corpses…
latent function REROL_ghouls_there_is_corpses(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(552454, true);

  if (!do_not_wait) {
    Sleep(4.044985); // Approved duration
  }
}

// Geralt: A fiend.
latent function REROL_a_fiend(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1039017, true);

  if (!do_not_wait) {
    Sleep(1.181657); // Approved duration
  }
}

// Geralt: A werewolf…
latent function REROL_a_werewolf(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(577129, true);

  if (!do_not_wait) {
    Sleep(1.114805); // Approved duration
  }
}

// Geralt: Everything says leshen, a young one. Must've arrived here recently. Need to find its totem.
latent function REROL_a_leshen_a_young_one(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(566287, true);

  if (!do_not_wait) {
    Sleep(6.950611); // Approved duration
  }
}

// Geralt: Where's that damned katakan?
latent function REROL_where_is_katakan(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(569579, true);

  if (!do_not_wait) {
    Sleep(1.694507); // Approved duration
  }
}

// Geralt: Gotta be an ekimmara.
latent function REROL_gotta_be_an_ekimmara(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1038390, true);

  if (!do_not_wait) {
    Sleep(1.589184); // Approved duration
  }
}

// Geralt: An earth elemental. Pretty powerful, too.
latent function REROL_an_earth_elemental(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(573116, true);

  if (!do_not_wait) {
    Sleep(2.965688); // Approved duration
  }
}

// Geralt choice: How'd a giant wind up here?
latent function REROL_giant_wind_up_here(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1167973, true);

  if (!do_not_wait) {
    Sleep(10); // Approved duration
  }
}

// Geralt: So… a griffin this close to the village? Strange.
latent function REROL_griffin_this_close_village(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1048275, true);

  if (!do_not_wait) {
    Sleep(4.37948); // Approved duration
  }
}

// Geralt: Wyvern. Wonderful.
latent function REROL_wyvern_wonderful(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1065583, true);

  if (!do_not_wait) {
    Sleep(2.04); // Approved duration
  }
}

// Geralt: A cockatrice…
latent function REROL_a_cockatrice(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(553797, true);

  if (!do_not_wait) {
    Sleep(2.04); // Approved duration
  }
}

// Geralt: Draconid, gotta be. Maybe a basilisk? Except… these prints don't belong to any variety I know. Just a liiiitle different.
latent function REROL_basilisk_a_little_different(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1170780, true);

  if (!do_not_wait) {
    Sleep(2.04); // Approved duration
  }
}

// Geralt: A flyer, swooped down… Judging by the claw marks, gotta be a wyvern or a forktail.
latent function REROL_a_flyer_forktail(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1034842, true);

  if (!do_not_wait) {
    Sleep(6.459111); // Approved duration
  }
}

// Geralt: Impossible. My brethren hunted down every last spotted wight before I was born.
latent function REROL_impossible_wight(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1179588, true);

  if (!do_not_wait) {
    Sleep(10); // Approved duration
  }
}

// Geralt: Whoa-ho. Shaelmaar's close…
latent function REROL_a_shaelmaar_is_close(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1169885, true);

  if (!do_not_wait) {
    Sleep(10); // Approved duration
  }
}

// Geralt: Gotta be a grave hag.
latent function REROL_gotta_be_a_grave_hag(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1022247, true);

  if (!do_not_wait) {
    Sleep(1.757565); // Approved duration
  }
}

// Geralt: Guess I'm dealing with an old foglet… hiding behind an illusion.
latent function REROL_dealing_with_foglet(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(550020, true);

  if (!do_not_wait) {
    Sleep(3.873405); // Approved duration
  }
}

// Geralt: A rock troll, looks like…
latent function REROL_a_rock_troll(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(579959, true);

  if (!do_not_wait) {
    Sleep(1.767925); // Approved duration
  }
}

// Geralt: Bruxa. Gotta be.
latent function REROL_bruxa_gotta_be(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1194000, true);

  if (!do_not_wait) {
    Sleep(3); // Approved duration
  }
}

// Geralt: Venom glands, long claws, a bloodsucker… must be a garkain. A pack leader, an alpha.
latent function REROL_a_garkain(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1176030, true);

  if (!do_not_wait) {
    Sleep(10); // Approved duration
  }
}

// Geralt: A nightwraith…
latent function REROL_a_nightwraith(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1019137, true);

  if (!do_not_wait) {
    Sleep(1.030744); // Approved duration
  }
}

// Geralt: Kikimores. Dammit.
latent function REROL_kikimores_dammit(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1164863, true);

  if (!do_not_wait) {
    Sleep(5); // Approved duration
  }
}

// Geralt: Wonder what lured the giant centipedes.
latent function REROL_what_lured_centipedes(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1200276, true);

  if (!do_not_wait) {
    Sleep(5); // Approved duration
  }
}

// Geralt: Where'd the wolf prints come from?
latent function REROL_where_did_wolf_prints_come_from(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(470770, true);

  if (!do_not_wait) {
    Sleep(1.614695); // Approved duration
  }
}

// Geralt: Half-man, half-bear. Something like a lycanthrope.
latent function REROL_half_man_half_bear(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(587721, true);

  if (!do_not_wait) {
    Sleep(5.995551); // Approved duration
  }
}

// Geralt: Animal hair.
latent function REROL_animal_hair(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1104764, true);

  if (!do_not_wait) {
    Sleep(3); // Approved duration
  }
}

// Geralt: An arachas.
latent function REROL_an_arachas(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(521492, true);

  if (!do_not_wait) {
    Sleep(3); // Approved duration
  }
}

// Geralt: Harpy feather, a rectrix.
latent function REROL_harpy_feather(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1000722, true);

  if (!do_not_wait) {
    Sleep(2.868078); // Approved duration
  }
}

// Geralt: Siren tracks. A very big siren.
latent function REROL_siren_tracks(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1025599, true);

  if (!do_not_wait) {
    Sleep(3.97284); // Approved duration
  }
}

// Geralt: Interesting.
latent function REROL_interesting(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(376165, true);

  if (!do_not_wait) {
    Sleep(3); // Approved duration
  }
}

// Geralt: Insect excretions…
latent function REROL_insectoid_excretion(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(376165, true);

  if (!do_not_wait) {
    Sleep(1.685808); // Approved duration
  }
}

// Geralt: Aha. So it's a slyzard…
latent function REROL_so_its_a_slyzard(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1204696, true);

  if (!do_not_wait) {
    Sleep(5); // Approved duration
  }
}

// Geralt choice: Pretty well armed, those bandits…
latent function REROL_well_armed_bandits(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1178439, true);

  if (!do_not_wait) {
    Sleep(7); // Approved duration
  }
}
