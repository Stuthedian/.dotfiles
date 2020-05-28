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
}

upload_to_tftp()
{
  DEVICE=$1
  if [ "$DEVICE" = "me5100" ] || [ "$DEVICE" = "me5200" ]; then
    cp ~/Docs/me-group/base/$DEVICE/out/$DEVICE/firmware_2.3.0.DEVEL-BUILD.$DEVICE /srv/tftp
    echo "Firmware uploaded to tftp. Enter 'copy tftp://192.168.192.13/firmware_2.3.0.DEVEL-BUILD.$DEVICE fs://firmware vrf mgmt-intf' on device"
    echo "copy tftp://192.168.192.13/firmware_2.3.0.DEVEL-BUILD.$DEVICE fs://firmware vrf mgmt-intf" | xclip -in -selection clipboard
  else
    cp ~/Docs/me-group/base/$DEVICE/out/fmc16/firmware_2.3.0.DEVEL-BUILD.fmc16 /srv/tftp
    echo "Firmware uploaded to tftp. Enter 'copy tftp://192.168.192.13/firmware_2.3.0.DEVEL-BUILD.fmc16 fs://firmware vrf mgmt-intf' on device"
    echo "copy tftp://192.168.192.13/firmware_2.3.0.DEVEL-BUILD.fmc16 fs://firmware vrf mgmt-intf" | xclip -in -selection clipboard
  fi
}

compile_firmware()
{
  ~/Docs/builder/builder.sh make fs dist
  if [[ $? -ne 0 ]]; then
    cd $current_dir
    alert &
    return
  fi
}

make_me5000()
{
  #alerts="xdotool key --repeat 30 --repeat-delay 250 Num_Lock"

  if [ -z $1 ]; then
    echo "No target name"
    alert &
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
    alert &
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
  alert &
}

foo()
{
  current_dir=$(pwd)
  DEVICE=$1
  TARGET=$2
  MAKE_ACTION=$3
  BEHAVIOUR=$4

  if [ -z $TARGET ]; then
    echo "Warning: no target for make - building all"
  fi
  cd ~/Docs/me-group/base/$DEVICE
  ~/Docs/builder/builder.sh make $TARGET MAKE_ACTION=$MAKE_ACTION
  if [[ $? -ne 0 ]]; then
    cd $current_dir
    alert &
    return
  fi
  if [ "$BEHAVIOUR" = "f" ] || [ "$BEHAVIOUR" = "bf" ]; then
    compile_firmware
    upload_to_tftp $1
  fi
  cd $current_dir
  alert &
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
  alert &
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
