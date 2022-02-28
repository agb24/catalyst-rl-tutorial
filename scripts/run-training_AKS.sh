#!/usr/bin/env bash
pyrep_src="/home/abharad3/git_packages_dwnld/pyrep/PyRep"
env_name="/home/abharad3/rl_pyenv"
tensorboard_port=7002
useGPU=0
useDBPORT=13013
logs_folder=/home/$USER/Desktop
series_name=tutorial_training
config=./configs/config.yml
seed=42


EXP_CONFIG=$config LOGDIR=$logs_folder/$series_name DBPORT=$useDBPORT . ./scripts/prepare_configs.sh
if [[ -z "$series_name" ]]; then
  tb_logdir=${CUR_TB_LOGDIR}; else
  tb_logdir=$logs_folder/$series_name;
fi
tmux new-session \; \
  send-keys 'source '$env_name'/bin/activate' C-m \; \
  send-keys 'tensorboard --logdir='${tb_logdir}' --port='$tensorboard_port' --bind_all' C-m \; \
  split-window -v \;\
  send-keys 'mongod --config configs/_mongod.conf' C-m \; \
  split-window -h \; \
  send-keys 'source '$env_name'/bin/activate' C-m \; \
  send-keys 'CUDA_VISIBLE_DEVICES='$useGPU' catalyst-rl run-trainer --config '$config C-m \; \
  split-window -h -t 0 \; \
  send-keys 'source '$env_name'/bin/activate' C-m \; \
  send-keys 'sleep 20s' C-m \; \
  send-keys 'CUDA_VISIBLE_DEVICES='$useGPU' catalyst-rl run-samplers --seed '$seed' --config '$config C-m \; \
