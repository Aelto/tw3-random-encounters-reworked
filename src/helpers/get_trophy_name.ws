
// It could have been simpler if a way to concatenate two `name` existed.
// Sadly it doesn't and i have to create this function and an enum value
// for each trophy. I'm sad.
function getTrophyName(trophy: RER_Trophy, trophy_price: TrophyVariant): name {
  if (trophy == Trophy_ARACHAS) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_arachas_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_arachas_trophy_medium';
    }
    else {
      return 'modrer_arachas_trophy_low';
    }
  }
  
  if (trophy == Trophy_INSECTOID) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_insectoid_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_insectoid_trophy_medium';
    }
    else {
      return 'modrer_insectoid_trophy_low';
    }
  }
  
  if (trophy == Trophy_NECROPHAGE) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_necrophage_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_necrophage_trophy_medium';
    }
    else {
      return 'modrer_necrophage_trophy_low';
    }
  }
  
  if (trophy == Trophy_NEKKER) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_nekker_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_nekker_trophy_medium';
    }
    else {
      return 'modrer_nekker_trophy_low';
    }
  }
  
  if (trophy == Trophy_WRAITH) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_wraith_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_wraith_trophy_medium';
    }
    else {
      return 'modrer_wraith_trophy_low';
    }
  }
  
  if (trophy == Trophy_HARPY) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_harpy_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_harpy_trophy_medium';
    }
    else {
      return 'modrer_harpy_trophy_low';
    }
  }
  
  if (trophy == Trophy_SPIRIT) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_spirit_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_spirit_trophy_medium';
    }
    else {
      return 'modrer_spirit_trophy_low';
    }
  }
  
  if (trophy == Trophy_BEAST) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_beast_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_beast_trophy_medium';
    }
    else {
      return 'modrer_beast_trophy_low';
    }
  }
  
  if (trophy == Trophy_WILDHUNT) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_wildhunt_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_wildhunt_trophy_medium';
    }
    else {
      return 'modrer_wildhunt_trophy_low';
    }
  }
  
  if (trophy == Trophy_LESHEN) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_leshen_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_leshen_trophy_medium';
    }
    else {
      return 'modrer_leshen_trophy_low';
    }
  }
  
  if (trophy == Trophy_WEREWOLF) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_werewolf_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_werewolf_trophy_medium';
    }
    else {
      return 'modrer_werewolf_trophy_low';
    }
  }
  
  if (trophy == Trophy_FIEND) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_fiend_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_fiend_trophy_medium';
    }
    else {
      return 'modrer_fiend_trophy_low';
    }
  }
  
  if (trophy == Trophy_EKIMMARA) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_ekimmara_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_ekimmara_trophy_medium';
    }
    else {
      return 'modrer_ekimmara_trophy_low';
    }
  }
  
  if (trophy == Trophy_KATAKAN) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_katakan_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_katakan_trophy_medium';
    }
    else {
      return 'modrer_katakan_trophy_low';
    }
  }
  
  if (trophy == Trophy_ELEMENTAL) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_elemental_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_elemental_trophy_medium';
    }
    else {
      return 'modrer_elemental_trophy_low';
    }
  }
  
  if (trophy == Trophy_NIGHTWRAITH) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_nightwraith_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_nightwraith_trophy_medium';
    }
    else {
      return 'modrer_nightwraith_trophy_low';
    }
  }
  
  if (trophy == Trophy_NOONWRAITH) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_noonwraith_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_noonwraith_trophy_medium';
    }
    else {
      return 'modrer_noonwraith_trophy_low';
    }
  }
  
  if (trophy == Trophy_CZART) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_czart_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_czart_trophy_medium';
    }
    else {
      return 'modrer_czart_trophy_low';
    }
  }
  
  if (trophy == Trophy_CYCLOP) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_cyclop_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_cyclop_trophy_medium';
    }
    else {
      return 'modrer_cyclop_trophy_low';
    }
  }
  
  if (trophy == Trophy_TROLL) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_troll_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_troll_trophy_medium';
    }
    else {
      return 'modrer_troll_trophy_low';
    }
  }
  
  if (trophy == Trophy_GRAVE_HAG) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_grave_hag_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_grave_hag_trophy_medium';
    }
    else {
      return 'modrer_grave_hag_trophy_low';
    }
  }
  
  if (trophy == Trophy_FOGLING) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_fogling_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_fogling_trophy_medium';
    }
    else {
      return 'modrer_fogling_trophy_low';
    }
  }
  
  if (trophy == Trophy_GARKAIN) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_garkain_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_garkain_trophy_medium';
    }
    else {
      return 'modrer_garkain_trophy_low';
    }
  }
  
  if (trophy == Trophy_VAMPIRE) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_vampire_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_vampire_trophy_medium';
    }
    else {
      return 'modrer_vampire_trophy_low';
    }
  }
  
  if (trophy == Trophy_GIANT) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_giant_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_giant_trophy_medium';
    }
    else {
      return 'modrer_giant_trophy_low';
    }
  }
  
  if (trophy == Trophy_SHARLEY) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_sharley_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_sharley_trophy_medium';
    }
    else {
      return 'modrer_sharley_trophy_low';
    }
  }
  
  if (trophy == Trophy_WIGHT) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_wight_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_wight_trophy_medium';
    }
    else {
      return 'modrer_wight_trophy_low';
    }
  }
  
  if (trophy == Trophy_GRIFFIN) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_griffin_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_griffin_trophy_medium';
    }
    else {
      return 'modrer_griffin_trophy_low';
    }
  }
  
  if (trophy == Trophy_COCKATRICE) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_cockatrice_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_cockatrice_trophy_medium';
    }
    else {
      return 'modrer_cockatrice_trophy_low';
    }
  }
  
  if (trophy == Trophy_BASILISK) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_basilisk_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_basilisk_trophy_medium';
    }
    else {
      return 'modrer_basilisk_trophy_low';
    }
  }

  if (trophy == Trophy_WYVERN) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_dracolizard_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_dracolizard_trophy_medium';
    }
    else {
      return 'modrer_dracolizard_trophy_low';
    }
  }
  
  if (trophy == Trophy_WYVERN) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_wyvern_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_wyvern_trophy_medium';
    }
    else {
      return 'modrer_wyvern_trophy_low';
    }
  }
  
  if (trophy == Trophy_FORKTAIL) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_forktail_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_forktail_trophy_medium';
    }
    else {
      return 'modrer_forktail_trophy_low';
    }
  }
  
  if (trophy == Trophy_TROLL) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_troll_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_troll_trophy_medium';
    }
    else {
      return 'modrer_troll_trophy_low';
    }
  }

  // if (trophy == Trophy_HUMAN) {
    if (trophy_price == TrophyVariant_PRICE_HIGH) {
      return 'modrer_human_trophy_high';
    }
    else if (trophy_price == TrophyVariant_PRICE_MEDIUM) {
      return 'modrer_human_trophy_medium';
    }
    else {
      return 'modrer_human_trophy_low';
    }
  // }
}
