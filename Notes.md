
# Notes
> Custom notes i write for myself to not forget them 😊

TODO:
  - actuellement les groupComposition utilisent `CreatureType` directement,
    le soucis est que lorsque c'est un type humain on ne peut plus faire la différence
    entre les multiples types d'humains. Il faut donc faire en sorte qu'à la place ça utilise
    la classe `BestiaryEntry`. Puisqu'il existe un `BestiaryEntry` pour chaque type d'humains