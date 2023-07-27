echo -e "\n\n\nSalesforce CLI version check\n"
sudo npm sfdx --version

echo "---------TEST----------"
echo "---------PWD-----------"
pwd

echo "---------LS-----------"
ls

echo "---------LS-2-----------"
$TEST=force-app/main/default
cd "$TEST"
ls