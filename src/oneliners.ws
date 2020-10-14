
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
latent function REROL_necrophages_great() {
  var scene: CStoryScene;
      
  scene = (CStoryScene)LoadResourceAsync(
    "dlc/dlc15/data/quests/quest_files/scenes/mq1058_geralt_oneliners.w2scene",
    true
  );

  theGame
  .GetStorySceneSystem()
  .PlayScene(scene, "NecropphagesComment"); // no typo from me there, the two "p"

  Sleep(2); // Approved duration
}

// Geralt: The Wild Hunt.
latent function REROL_the_wild_hunt() {
  // this integer corresponds to the hexa found in the `witcher_dialogs.csv` file
  // converted to integer.
  thePlayer.PlayLine(539883, true);

  Sleep(1.72); // Approved duration
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
