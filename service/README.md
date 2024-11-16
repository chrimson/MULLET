# Machine Learning LTE RF Fingerprinting

## Service Application

Copy generated RFF Waveforms (RWF) from the dataset of __s1_LTE_RWF_dataset.m__

```
mkdir dataset
cp ../25x20_ue_rwf_data/* dataset/
```

Copy saved model and encoded labels from __s2_BuildTrainCNN.py__ if you don't want to wait

```
cp ../25x20_rwf_cnn.keras rwf.keras
cp ../25x20_mac_label_enc.pkl rwf.pkl
```

Launch service in one terminal

```
python service.py
```

In a different terminal, copy RWFs to staging directory, play with different MAC addresses, etc. Observe flag directory

```
cp ../25x20_ue_rwf_data/33-04-E7-92-52-BD/0001 stage/33-XX-XX-XX-XX-XX
cp ../25x20_ue_rwf_data/33-04-E7-92-52-BD/0046 stage/33-04-E7-92-52-BD
cp ../25x20_ue_rwf_data/4A-2C-09-12-C0-1C/0024 stage/4A-2C-09-12-C0-1C

Chris@MULLET:~/MULLET/src/LteRffSvc$ ls -lR flag/
flag/:
33-XX-XX-XX-XX-XX_33-04-E7-92-52-BD
flag/33-XX-XX-XX-XX-XX_33-04-E7-92-52-BD:
0000
```

Observe service operations in the first terminal

```
2024-11-13 04:05:08.118159 Read 50 MACs and their variant RWFs from dataset
2024-11-13 04:05:08.922803 Read 40-3B-7B-23-50-20 50 Variants
2024-11-13 04:05:09.779825 Read 4D-22-47-3E-13-CE 50 Variants
...
2024-11-13 04:05:43.432723 Read 33-04-E7-92-52-BD 50 Variants
2024-11-13 04:17:23.811551 Monitoring ./stage/

2024-11-13 04:19:48.817076 Import target RWF from stage
2024-11-13 04:19:48.868890 Guess 33-04-E7-92-52-BD Probability 95.20%
2024-11-13 04:19:48.869099 Claim 33-XX-XX-XX-XX-XX Probability N/A
2024-11-13 04:19:48.871216 Diff MACs, RWF > 80% Flag for examination

2024-11-13 04:20:28.873006 Import target RWF from stage
2024-11-13 04:20:28.921321 Guess 33-04-E7-92-52-BD Probability 95.20%
2024-11-13 04:20:28.922340 Claim 33-04-E7-92-52-BD Probability 95.20%
2024-11-13 04:20:28.923424 Same MACs, RWF >= 50% Checks out

2024-11-13 04:29:19.151990 Import target RWF from stage
2024-11-13 04:29:19.193609 Guess 4A-2C-09-12-C0-1C Probability 43.32%
2024-11-13 04:29:19.194691 Claim 4A-2C-09-12-C0-1C Probability 43.32%
2024-11-13 04:29:19.195369 Same MACs, RWF < 50% Strengthen
2024-11-13 04:29:19.307411 Build and train
Epoch 1/10
125/125 - 69s - 555ms/step - accuracy: 0.0160 - loss: 4.1045 - val_accuracy: 0.0140 - val_loss: 3.9546
Epoch 2/10
125/125 - 81s - 645ms/step - accuracy: 0.0185 - loss: 3.9534 - val_accuracy: 0.0140 - val_loss: 3.9422
...
Epoch 9/10
125/125 - 66s - 532ms/step - accuracy: 0.0205 - loss: 3.8623 - val_accuracy: 0.0439 - val_loss: 3.8085
Epoch 10/10
125/125 - 84s - 670ms/step - accuracy: 0.0375 - loss: 3.6918 - val_accuracy: 0.0499 - val_loss: 3.6574
2024-11-13 04:41:18.055316 Done
```

After rebuilding the model with new data, service predictions actually seemed to worsen. MAC encoding was changed from inline to unique NumPy array, and that seemed to have fixed it

Can accelerate system with TensorFlow GPU-enabled engine on suitable machines like AWS GPU CUDA

## To Do

REST Web Service API, accept submissions of SigMF

Restore applicable impairments

Can eventually test with two hardware SDRs