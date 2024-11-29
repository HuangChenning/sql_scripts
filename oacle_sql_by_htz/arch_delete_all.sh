rman target / <<EOF
delete noprompt archivelog all;
exit;
EOF;
