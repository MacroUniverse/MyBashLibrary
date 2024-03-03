while :
do
    date;
    printf "1.moving in...";
    ./mv_in.sh;
    cd .MacroUniverse_GIT;
    printf "2.git reset...";
    git reset --hard;
    printf "3.git clean...";
    git clean -fd;
    cd ../;
    printf "4.moving out...";
    ./mv_out.sh;
    printf "done!\n\n";
    sleep 3600;
done
