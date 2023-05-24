# arg : $1 => ip 
# ne marque que sur le loghost
# pour que ca marche à distance : ssh "root:$1" ufw deny from $1 to any port 22 (necessite une préconfiguration)

sudo ufw deny from $1 to any port 22
