vicd()
{

    local dst="$(command vifm --choose-dir - "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    cd "$dst"
}

stand()
{
    ~/stand.exp $1 $2
    tmux rename-window "stand"
	#case $1 in
	#1) ssh 192.168.192.201 -l user;;
	#2) ssh 192.168.192.211 -l user;;
	#3) ssh 192.168.192.221 -l user;;
	#*) echo "Expected apropriate stand number";;
	#esac
}

flash_led()
{
    #xdotool key --repeat 30 --repeat-delay 250 Num_Lock;
    alert
}

upload_to_tftp()
{
	mv ~/Docs/me-group/base/$1/out/$1/firmware_2.3.0.DEVEL-BUILD.$1 ~/Docs/me-group/base/$1/out/$1/firmware_2.3.0.$2.$1
	cp ~/Docs/me-group/base/$1/out/$1/firmware_2.3.0.$2.$1 /srv/tftp
	echo "Firmware uploaded to tftp. Enter 'copy tftp://192.168.192.13/firmware_2.3.0.$2.$1 fs://firmware vrf mgmt-intf' on device"
	echo "copy tftp://192.168.192.13/firmware_2.3.0.$2.$1 fs://firmware vrf mgmt-intf" | xclip -in -selection clipboard
}

compile_firmware()
{
	~/Docs/builder/builder.sh make fs dist
	if [[ $? -ne 0 ]]; then
		cd $current_dir
		flash_led &
		return
	fi
}

make_me5000()
{
	#flash_leds="xdotool key --repeat 30 --repeat-delay 250 Num_Lock"

	if [ -z $1 ]; then
		echo "No target name"
		flash_led &
		return
	fi
	if [ -z $2 ]; then
		echo "Warning: no target for make - building all"
	fi
	current_dir=$(pwd)
	firmware_path=~/Docs/me-group/base/me5000/out/fmc16
	firmware=firmware_2.3.0.$1.fmc16
	cd ~/Docs/me-group/base/me5000/fmc16
	~/Docs/builder/builder.sh make $2
	if [[ $? -ne 0 ]]; then
		cd $current_dir
		flash_led &
		return
	fi
	cd ..
	if [ "$4" = "firmware" ]; then
        compile_firmware
        mv $firmware_path/firmware_2.3.0.DEVEL-BUILD.fmc16 $firmware_path/$firmware
        cp $firmware_path/$firmware /srv/tftp
        echo "Firmware uploaded to tftp. Enter 'copy tftp://192.168.192.13/$firmware fs://firmware vrf mgmt-intf' on device"
        echo "copy tftp://192.168.192.13/$firmware fs://firmware vrf mgmt-intf" | xclip -in -selection clipboard
        #upload_to_tftp me5000 $2
	fi
	cd $current_dir
	flash_led &
}

foo()
{
	current_dir=$(pwd)

	if [ -z $2 ]; then
		echo "No target name"
		return
	fi
	if [ -z $3 ]; then
		echo "Warning: no target for make - building all"
	fi
	cd ~/Docs/me-group/base/$1
	~/Docs/builder/builder.sh make $3
	if [[ $? -ne 0 ]]; then
		cd $current_dir
		flash_led &
		return
	fi
	if [ "$4" = "firmware" ]; then
        compile_firmware
        upload_to_tftp $1 $2
	fi
	cd $current_dir
    flash_led &
}

make_me5100()
{
	foo me5100 $1 $2 $3
}

make_me5200()
{
	foo me5200 $1 $2 $3
}

make_sim()
{
	current_dir=$(pwd)
	cd ~/Docs/me-group/base/sim
	~/Docs/builder/builder.sh "$@"
	cd $current_dir
    flash_led &
}

Dshell()
{
	~/Docs/builder/builder.sh shell
}

show_branches()
{
    synchronize_repo git rev-parse --abbrev-ref HEAD
}

synchronize_repo()
{
	for dir in *
	do
		if ! [ -d $dir ]; then
			continue
		fi
		cd "$dir"
		echo -e "\e[43m\e[30m$dir\e[0m"
		"$@"
		cd ..
	done
}

bake()
{
    DEVICE=$(cat ~/.device)
    TARGET=$(cat ~/.target)
    BEHAVIOUR=$(cat ~/.behaviour)

    if [ -z $DEVICE ]; then
        echo "No target device, aborting"
        return
    fi
    if [ -z $TARGET ]; then
        echo "Warning: no target for make - building all"
    fi
    if [ "$1" = "-b" ]; then
        BEHAVIOUR="build"
    elif [ "$1" = "-f" ]; then
        BEHAVIOUR="firmware"
    fi
    if [ $BEHAVIOUR != "build" ] && [ $BEHAVIOUR != "firmware" ]; then
        echo "Unrecognized behaviour: $BEHAVIOUR"
        return
    fi

    tmux rename-window "🔨$DEVICE $TARGET $BEHAVIOUR🔨"

    case $DEVICE in
        me5000) make_me5000 dummy $TARGET $BEHAVIOUR;;
        me5100) make_me5100 dummy $TARGET $BEHAVIOUR;;
        me5200) make_me5200 dummy $TARGET $BEHAVIOUR;;
        *) tmux rename-window "bash"
           echo "Invalid device name";;
    esac
    tmux rename-window "bash"
}

bake_env()
{
    DEVICE=$(cat ~/.device)
    TARGET=$(cat ~/.target)
    BEHAVIOUR=$(cat ~/.behaviour)
    echo "Device: $DEVICE   Target: $TARGET    Behaviour: $BEHAVIOUR"
}

statall()
{
    for dir in ~/Docs/me-group/*
    do
        if ! [ -d $dir ]; then
            continue
        fi
        cd "$dir"
        echo -e "\e[43m\e[30m$dir\e[0m"
        git status -sb | head -1
        cd ..
    done
}