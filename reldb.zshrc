#!/dev/null

# cpo_append $1=ASID $2=AMBPM $3=MPTKEY $4=TITLE
cpo_reldb_append() {
  CPO_RELDB_KEYS+=($1)
  CPO_RELDB_FIELD_AMBPM+=([$1]=$2)
  CPO_RELDB_FIELD_MPTKEY+=([$1]=$3)
  CPO_RELDB_FIELD_TITLE+=([$1]=$4)
}

cpo_reldb_dump() {
  declare -p1 CPO_RELDB_KEYS
  declare -p1 CPO_RELDB_FIELD_AMBPM
  declare -p1 CPO_RELDB_FIELD_MPTKEY
  declare -p1 CPO_RELDB_FIELD_TITLE
}

cpo_reldb_print() {
  echo
  echo ${CPO_RELDB_KEYS[*]}
  echo
  echo ${(k)CPO_RELDB_FIELD_TITLE}
  echo
  echo ${(v)CPO_RELDB_FIELD_TITLE}
  echo
  echo ${(kv)CPO_RELDB_FIELD_TITLE}
  echo
  for k in ${CPO_RELDB_KEYS[@]}; do printf "https://music.apple.com/us/song/%-10s . %s\n" $k $CPO_RELDB_FIELD_TITLE[$k]; done
  echo
}

cpo_reldb_init() {

  declare -g -a CPO_RELDB_KEYS
  declare -g -A CPO_RELDB_FIELD_AMBPM
  declare -g -A CPO_RELDB_FIELD_MPTKEY
  declare -g -A CPO_RELDB_FIELD_TITLE

  # key symbol /[A-G][_ib]/
  # i is SHARP
  # _ is NATUAL
  # b is FLAT

  # cpo_reldb_append 1566041338       "172" "D_" "House Of The Lord"
  # cpo_reldb_append 993160497        "122" "G_" "Trading My Sorrows"
  # cpo_reldb_append 655662082        "130" "E_" "You Are Good"
  # cpo_reldb_append 715720012        "156" "A_" "Worthy Is the Lamb"
  # cpo_reldb_append 1175720998       "120" "C_" "Way Maker"
  # cpo_reldb_append 1019249219       "136" "A_" "There Is None Like You"
  # cpo_reldb_append 1440837672 "(6/8) 100" "A_" "Good Good Father"
  # cpo_reldb_append 1443158231       "128" "E_" "Amazing Grace My Chains Are Gone"
  # cpo_reldb_append 1502316160       "142" "B_" "The Blessing"
  # cpo_reldb_append 1192789624       "172" "G_" "Do It Again"

  # cpo_reldb_append 2574411984       "100" "F_" "What a Friend We Have in Jesus"

  # cpo_reldb_append 1639032653       "999" "E_" "Arise"
  # cpo_reldb_append 724575185        "999" "B_" "Blessed Be Your Name"
  cpo_reldb_append 1457082236       "999" "E_" "Sing for Joy"
  # cpo_reldb_append 646708668        "999" "G_" "Lord I Lift Your Name On High"

}

cpo_reldb_init
