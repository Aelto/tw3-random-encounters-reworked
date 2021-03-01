
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
latent function REROL_wonder_clues_will_lead_me(optional do_not_wait: bool) {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests\generic_quests\novigrad\quest_files\mh307_minion\scenes\mh307_02_investigation.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "All_clues_in");

  if (!do_not_wait) {
    Sleep(3.8); // Approved duration
  }
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
latent function REROL_there_you_are(optional do_not_wait: bool) {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "quests/part_1/quest_files/q103_daughter/scenes/q103_08f_gameplay_geralt.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "spot_goat_in");

  if (!do_not_wait) {
    Sleep(1.32); // Approved duration
  }
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
latent function REROL_should_look_around(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(397220, true);

  if (!do_not_wait) {
    Sleep(1.390483); // Approved duration
  }
}

// Geralt: Hm… Definitely came through here.
latent function REROL_came_through_here(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(382001, true);

  if (!do_not_wait) {
    Sleep(2.915713); // Approved duration
  }
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
latent function REROL_mhm(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1185176, true);

  if (!do_not_wait) {
    Sleep(1.5); // could not find Approved duration
  }
}
class REROL_mhm_data extends RER_DialogData {
  default dialog_id = 1185176;
  default dialog_duration = 1.5;
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

// Geralt: Trail ends here.
latent function REROL_trail_ends_here(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1091477, true);

  if (!do_not_wait) {
    Sleep(4); // Approved duration
  }
}

// Geralt: Damn, trail breaks off. Could find something else, though.
latent function REROL_trail_breaks_off(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(525769, true);

  if (!do_not_wait) {
    Sleep(5.24); // Approved duration
  }
}


// Geralt: Hmm, trail goes on. Good thing it doesn't end here.
latent function REROL_trail_goes_on(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(393988, true);

  if (!do_not_wait) {
    Sleep(4.365868); // Approved duration
  }
}

// Geralt choice: Wonder why they split up.
latent function REROL_wonder_they_split(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(568165, true);

  if (!do_not_wait) {
    Sleep(3); // Approved duration
  }
}

// Geralt: Nothing.
latent function REROL_nothing(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1153912, true);

  if (!do_not_wait) {
    Sleep(1.5); // Approved duration
  }
}

// Geralt: Nothing here.
latent function REROL_nothing_here(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1093719, true);

  if (!do_not_wait) {
    Sleep(1.5); // Approved duration
  }
}

// Geralt: Hmm... Nothing interesting.
latent function REROL_nothing_interesting(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1130083, true);

  if (!do_not_wait) {
    Sleep(1.5); // Approved duration
  }
}

// Geralt: Must know the area well…
latent function REROL_must_know_area_well(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(487162, true);

  if (!do_not_wait) {
    Sleep(1.5); // TODO: Approved duration
  }
}
class REROL_must_know_area_well_data extends RER_DialogData {
  default dialog_id = 487162;
  default dialog_duration = 1.5;
}

// Geralt: I'll check the area.
latent function REROL_ill_check_area(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(588352, true);

  if (!do_not_wait) {
    Sleep(1.5); // TODO: Approved duration
  }
}
class REROL_ill_check_area_data extends RER_DialogData {
  default dialog_id = 588352;
  default dialog_duration = 1.5;
}

// Geralt: Not likely to learn anything more here.
latent function REROL_not_likely_learn_anything_from_here(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1202374, true);

  if (!do_not_wait) {
    Sleep(2); // TODO: Approved duration
  }
}
class REROL_not_likely_learn_anything_from_here_data extends RER_DialogData {
  default dialog_id = 1202374;
  default dialog_duration = 2;
}

// Geralt: See if I can learn what's out there.
latent function REROL_see_if_i_can_learn_what_out_there(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1041656, true);

  if (!do_not_wait) {
    Sleep(2); // TODO: Approved duration
  }
}
class REROL_see_if_i_can_learn_what_out_there_data extends RER_DialogData {
  default dialog_id = 1041656;
  default dialog_duration = 2;
}

// Geralt: That's about all I've learned.
latent function REROL_about_all_ive_learned(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(389189, true);

  if (!do_not_wait) {
    Sleep(2); // TODO: Approved duration
  }
}
class REROL_about_all_ive_learned_data extends RER_DialogData {
  default dialog_id = 389189;
  default dialog_duration = 2;
}

// Geralt: Not likely to learn anymore here.
latent function REROL_not_likely_learn_anymore(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(1071533, true);

  if (!do_not_wait) {
    Sleep(1.5); // TODO: Approved duration
  }
}
class REROL_not_likely_learn_anymore_data extends RER_DialogData {
  default dialog_id = 1071533;
  default dialog_duration = 1.5;
}

// Geralt: Watch and learn.
latent function REROL_watch_and_learn(optional do_not_wait: bool) {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(380546, true);

  if (!do_not_wait) {
    Sleep(1.5); // TODO: Approved duration
  }
}
class REROL_watch_and_learn_data extends RER_DialogData {
  default dialog_id = 380546;
  default dialog_duration = 1.5;
}

class REROL_your_problem_is_my_problem extends RER_DialogData {
  default dialog_id = 1176632;
}

// Geralt choice: Get rid of these bandits, worse ones'll come in to replace 'em.
class REROL_no_point_fighting_bandits extends RER_DialogData {
  default dialog_id = 1176605;
}

// Geralt choice: Get rid of these bandits, worse ones'll come in to replace 'em.
class REROL_get_rid_of_bandits extends RER_DialogData {
  default dialog_id = 1176605;
}

// Geralt: Eh, fine, your choice. So show me where the monster attacked you.
class REROL_fine_show_me_where_monsters extends RER_DialogData {
  default dialog_id = 1097265;
}

// Geralt: Think these boys could've handled some monsters?
class REROL_boys_could_handle_monsters extends RER_DialogData {
  default dialog_id = 474279;
}

// Geralt: What's the surprise? Some new monster I need to kill?
class REROL_what_surprise_new_monster_to_kill extends RER_DialogData {
  default dialog_id = 1201113;
}

// Geralt: Got a different plan.
class REROL_got_a_different_plan extends RER_DialogData {
  default dialog_id = 1176628;
}

// Geralt: Fine. I'll see what I can do.
class REROL_fine_ill_see_what_i_can_do extends RER_DialogData {
  default dialog_id = 1205174;
}

// Geralt: So, plan to go out and meet the bandits when they arrive? Fight them?
class REROL_so_plan_to_go_out_and_meet_bandits extends RER_DialogData {
  default dialog_id = 1176438;
}

// Geralt: How'd he die? Where'd they find the body?
class REROL_how_did_he_die_where_find_body extends RER_DialogData {
  default dialog_id = 1168533;
}

// Geralt: I see the wounds, might be able to tell what kind of monster killed them.
class REROL_i_see_the_wounds extends RER_DialogData {
  default dialog_id = 570951;
}

// Geralt: Won't give me any trouble with the reward, will you?
class REROL_wont_give_me_any_trouble extends RER_DialogData {
  default dialog_id = 570958;
}

// Geralt: Any witnesses to these attacks? Anyone see the beast?
class REROL_any_witnesses extends RER_DialogData {
  default dialog_id = 570953;
}

// Geralt: Not sure you actually get what it is I do. I'm a professional monster slayer.
class REROL_im_a_monster_slayer extends RER_DialogData {
  default dialog_id = 1154437;
}

// Geralt: All right. We can start.
class REROL_alright_we_can_start extends RER_DialogData {
  default dialog_id = 1151460;
}

// Geralt: I see the wounds, might be able to tell what kind of monster killed them.
class REROL_see_the_wounds_what_kind_of_monster extends RER_DialogData {
  default dialog_id = 570951;
}

class REROL_give_me_a_minute extends RER_DialogData {
  default dialog_id = 1196680;
}

class REROL_not_the_first_time extends RER_DialogData {
  default dialog_id = 1196682;
}

// Geralt: What the hell happened?
class REROL_what_the_hell_happened extends RER_DialogData {
  default dialog_id = 1184103;
}

// Geralt: Don't care. Down to business - you learn anything?
class REROL_dont_care extends RER_DialogData {
  default dialog_id = 1199256;
}

// Geralt choice: Need a bit longer.
class REROL_need_a_bit_longer extends RER_DialogData {
  default dialog_id = 1199249;
}

// Geralt: Not sure it's a monster, and I don't take sides in the war.
class REROL_not_sure_monster_no_side_war extends RER_DialogData {
  default dialog_id = 1020985;
}

// Geralt: Whoa, this is work for a witcher, not for your guardsmen.
class REROL_this_is_work_for_witcher extends RER_DialogData {
  default dialog_id = 1170859;
}

// Geralt: Go ahead, send them to their death. Certain death.
class REROL_send_them_certain_death extends RER_DialogData {
  default dialog_id = 1170863;
}

// Geralt: Less moaning, more details. What happened? And how can I help? And remember, I don't work for free - witchers' code and all.
class REROL_less_moaning extends RER_DialogData {
  default dialog_id = 1030584;
}

//#region Damien's voicelines

// Damien: Greetings, witcher.
class REROL_damien_greetings_witcher extends RER_DialogData {
  default dialog_id = 1150342;
}

// Damien: Witcher… I was certain you'd departed.
class REROL_damien_i_was_certain_you_departed extends RER_DialogData {
  default dialog_id = 1187718;
}

class REROL_damien_you_killed_it_alone extends RER_DialogData {
  default dialog_id = 1180711;
}

// Damien: He had died of wounds inflicted with claws, not a weapon. Blows of great force."
class REROL_damien_he_died_claws extends RER_DialogData {
  default dialog_id = 1168537;
}

// Damien: Do you believe me an amateur? Not hands, but claws killed Ramon du Lac. The wound was deep, clean.
class REROL_damien_do_you_believe_me_an_amateur extends RER_DialogData {
  default dialog_id = 1168653;
}

// Damien: I thank you, witcher. For alerting me. And I appreciate your attentiveness.
class REROL_damien_i_thank_you_witcher extends RER_DialogData {
  default dialog_id = 1177101;
}

// Damien: You are certain of this?
class REROL_damien_you_certain_of_this extends RER_DialogData {
  default dialog_id = 1171453;
}

class REROL_damien_how extends RER_DialogData {
  default dialog_id = 1176634;
}

// Damien: Hm. And what would that be?
class REROL_damien_and_what_would_that_be extends RER_DialogData {
  default dialog_id = 1176630;
}

class REROL_damien_sworn_loyalty_to_her_grace extends RER_DialogData {
  default dialog_id = 1180730;
}

class REROL_damien_wait extends RER_DialogData {
  default dialog_id = 1180770;
}

// Damien: Honestly? I've no clue. Look, I've told you what I saw. What you do with it is no concern of mine."
class REROL_damien_i_told_you_what_i_saw extends RER_DialogData {
  default dialog_id = 1151551;
}

class REROL_damien_thank_you_i_hope_youre_worth_the_coin extends RER_DialogData {
  default dialog_id = 1176622;
}

class REROL_damien_do_not_tarry_time_is_not_our_friend extends RER_DialogData {
  default dialog_id = 1196684;
}

// Damien: Your plan puts you at great risk… but I sense you will handle it well. Let us go.
class REROL_damien_i_sense_you_will_handle_it extends RER_DialogData {
  default dialog_id = 1200318;
}

// Damien: Crespi was the first to die. He was famed once for his many glorious tournament victories. Then he grew old, hung up his sword and took to wine making.
class REROL_damien_crespi_was_the_first_to_die extends RER_DialogData {
  default dialog_id = 1168529;
}

// Damien: Hmm… I should double the patrols. Just in case.
class REROL_damien_i_should_double_patrols extends RER_DialogData {
  default dialog_id = 1201534;
}

// Damien: Good luck. I hope you get the bastard.
class REROL_damien_good_luck extends RER_DialogData {
  default dialog_id = 1201510;
}

// Damien: Bandits attacked us, not a small force, either. One of my boys has a broken arm, another, a shattered knee… lamed for life.
class REROL_damien_bandits_attack_us extends RER_DialogData {
  default dialog_id = 1199381;
}

// Damien: I will start at the beginning…
class REROL_damien_will_start_at_the_beginning extends RER_DialogData {
  default dialog_id = 1199258;
}

// Damien: Must you always…? Now…
class REROL_damien_must_you_always extends RER_DialogData {
  default dialog_id = 1199254;
}

// Damien: If that's how you wish to treat it…
class REROL_damien_if_thats_how_you_treat_it extends RER_DialogData {
  default dialog_id = 1185779;
}

// Damien: At any rate, I see the effort you put forth. And I appreciate it.
class REROL_damien_i_see_the_effort_you_put extends RER_DialogData {
  default dialog_id = 1185793;
}

// Damien: Witcher, a moment… I was wrong about you.
class REROL_damien_i_was_wrong_about_you extends RER_DialogData {
  default dialog_id = 1185755;
}

// Damien: That was the plan, but…
class REROL_damien_that_was_the_plan_but extends RER_DialogData {
  default dialog_id = 1185732;
}

// Damien: Do you mean to insinuate the investigation thus far has been sloppy?
class REROL_damien_you_insinuate_investigation_has_been_sloppy extends RER_DialogData {
  default dialog_id = 1168451;
}

// Damien: Who sent you?
class REROL_damien_who_sent_you extends RER_DialogData {
  default dialog_id = 1185804;
}

// Damien: Go on, man. Spit it out.
class REROL_damien_spit_it_out extends RER_DialogData {
  default dialog_id = 1163944;
}

// Damien: For once, I agree with you. We will do as you say. Let me know when you are ready.
class REROL_damien_i_agree_with_you extends RER_DialogData {
  default dialog_id = 1171963;
}

// Damien: Where to, witcher? We've a mission to complete.
class REROL_damien_where_to_mission_to_complete extends RER_DialogData {
  default dialog_id = 1193705;
}

// Damien: Make haste. We await only you.
class REROL_damien_we_await_only_you extends RER_DialogData {
  default dialog_id = 1162270;
}

// Damien: Why do you wait?! Save them!
class REROL_damien_why_do_you_wait_save_them extends RER_DialogData {
  default dialog_id = 1207814;
}

// Damien: Onward, witcher!
class REROL_damien_onward_witcher extends RER_DialogData {
  default dialog_id = 1207812;
}

// Damien: I was not mistaken. You arrived and trouble followed soon after.
class REROL_damien_you_arrive_trouble_followed extends RER_DialogData {
  default dialog_id = 1170802;
}

// Damien: Then what can we do? Do you have a plan?
class REROL_damien_do_you_have_a_plan extends RER_DialogData {
  default dialog_id = 1181615;
}

// Damien: Make haste! Time is of the essence…
class REROL_damien_make_haste extends RER_DialogData {
  default dialog_id = 1170938;
}

// Damien: Yet all are still brainless beasts.
class REROL_damien_all_brainless_beasts extends RER_DialogData {
  default dialog_id = 1179345;
}

// Damien: To a lone witcher, perhaps. To forty of my men at arms, but another skirmish.
class REROL_damien_to_a_lone_witcher extends RER_DialogData {
  default dialog_id = 1170865;
}

// Damien: You have not seen my guardsmen in action.
class REROL_damien_my_guardsmen_in_action extends RER_DialogData {
  default dialog_id = 1179336;
}

// Damien: Pfff, is this a problem? Is it too much for a witcher? A monster slayer?  But everyone knows how to end a vampire. Draw him by trick into sunlight. Or arm yourself with ample garlic and drive a stake through its heart.
class REROL_damien_is_this_a_problem extends RER_DialogData {
  default dialog_id = 1179219;
}

// Damien: So it seems.
class REROL_damien_so_it_seems extends RER_DialogData {
  default dialog_id = 1168543;
}

// Damien: Very well. But you must behave. Less like a hired thug and more like a man deserving of the duchy's highest honor.
class REROL_damien_very_well_you_must_behave_less_like_thug extends RER_DialogData {
  default dialog_id = 1161577;
}

// Damien: I've heard much about you. You bring trouble, or thus far have, always. And we've enough trouble as it is. Yet we are capable of defeating the Beast on our own, without an outsider's help. I've no doubt about it.
class REROL_damien_ive_heard_much_about_you extends RER_DialogData {
  default dialog_id = 1168024;
}

// Damien: In fact, you'd do best to maintain a dignified silence throughout.
class REROL_damien_youd_best_maintain_silence extends RER_DialogData {
  default dialog_id = 1161579;
}
//#endregion Damien's voicelines