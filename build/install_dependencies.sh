echo -e "\n\n\nSalesforce CLI version check\n"
sudo npm sfdx --version

echo "---------TEST----------"
echo "---------PWD-----------"
pwd
TEST2=$( echo pwd )

echo "---------LS-----------"
ls

echo "---------LS-2-----------"
TEST="force-app/main/default"
echo $TEST
echo "---------LS-2-----------"
cd $TEST
#cd -- "$TEST"
ls

echo "---------LS-3-----------"
cd $TEST2
ls

#cd -- "$dirName"