

#---------------------------------
# New invocation of recon-all Fri Sep 13 22:36:07 UTC 2019 

 mri_convert /tmp/work/dmriprep_wf/single_subject_THP0005_wf/anat_preproc_wf/anat_template_wf/t1_merge/sub-THP0005_ses-THP0005JHU1_run-02_T1w_ras_template.nii.gz /out/freesurfer/sub-THP0005/mri/orig/001.mgz 

#--------------------------------------------
#@# T2/FLAIR Input Fri Sep 13 22:36:18 UTC 2019

 mri_convert --no_scale 1 /data/sub-THP0005/ses-THP0005JHU1/anat/sub-THP0005_ses-THP0005JHU1_run-01_T2w.nii.gz /out/freesurfer/sub-THP0005/mri/orig/T2raw.mgz 

#--------------------------------------------
#@# MotionCor Fri Sep 13 22:36:20 UTC 2019

 cp /out/freesurfer/sub-THP0005/mri/orig/001.mgz /out/freesurfer/sub-THP0005/mri/rawavg.mgz 


 mri_convert /out/freesurfer/sub-THP0005/mri/rawavg.mgz /out/freesurfer/sub-THP0005/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /out/freesurfer/sub-THP0005/mri/transforms/talairach.xfm /out/freesurfer/sub-THP0005/mri/orig.mgz /out/freesurfer/sub-THP0005/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Fri Sep 13 22:36:31 UTC 2019

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

#--------------------------------------------
#@# Talairach Failure Detection Fri Sep 13 22:37:57 UTC 2019

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /opt/freesurfer/bin/extract_talairach_avi_QA.awk /out/freesurfer/sub-THP0005/mri/transforms/talairach_avi.log 


 tal_QC_AZS /out/freesurfer/sub-THP0005/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Fri Sep 13 22:37:58 UTC 2019

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 


 mri_add_xform_to_header -c /out/freesurfer/sub-THP0005/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Fri Sep 13 22:39:41 UTC 2019

 mri_normalize -g 1 -mprage nu.mgz T1.mgz 



#---------------------------------
# New invocation of recon-all Fri Sep 13 23:01:33 UTC 2019 
#-------------------------------------
#@# EM Registration Fri Sep 13 23:01:40 UTC 2019

 mri_em_register -rusage /out/freesurfer/sub-THP0005/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize Fri Sep 13 23:05:41 UTC 2019

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Fri Sep 13 23:06:55 UTC 2019

 mri_ca_register -rusage /out/freesurfer/sub-THP0005/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg Sat Sep 14 00:37:59 UTC 2019

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz 


 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /out/freesurfer/sub-THP0005/mri/transforms/cc_up.lta sub-THP0005 

#--------------------------------------
#@# Merge ASeg Sat Sep 14 01:15:07 UTC 2019

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Sat Sep 14 01:15:07 UTC 2019

 mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Sat Sep 14 01:17:20 UTC 2019

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Sat Sep 14 01:17:23 UTC 2019

 mri_segment -mprage brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Sat Sep 14 01:18:55 UTC 2019

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz 



#---------------------------------
# New invocation of recon-all Sat Sep 14 02:24:32 UTC 2019 


#---------------------------------
# New invocation of recon-all Sat Sep 14 02:24:32 UTC 2019 
#--------------------------------------------
#--------------------------------------------
#@# Refine Pial Surfs w/ T2/FLAIR Sat Sep 14 02:24:39 UTC 2019
#@# Refine Pial Surfs w/ T2/FLAIR Sat Sep 14 02:24:39 UTC 2019

 bbregister --s sub-THP0005 --mov /out/freesurfer/sub-THP0005/mri/orig/T2raw.mgz --lta /out/freesurfer/sub-THP0005/mri/transforms/T2raw.auto.lta --init-coreg --T2 


 bbregister --s sub-THP0005 --mov /out/freesurfer/sub-THP0005/mri/orig/T2raw.mgz --lta /out/freesurfer/sub-THP0005/mri/transforms/T2raw.auto.lta --init-coreg --T2 


 cp /out/freesurfer/sub-THP0005/mri/transforms/T2raw.auto.lta /out/freesurfer/sub-THP0005/mri/transforms/T2raw.lta 


 mri_convert -odt float -at /out/freesurfer/sub-THP0005/mri/transforms/T2raw.lta -rl /out/freesurfer/sub-THP0005/mri/orig.mgz /out/freesurfer/sub-THP0005/mri/orig/T2raw.mgz /out/freesurfer/sub-THP0005/mri/T2.prenorm.mgz 


 mri_normalize -sigma 0.5 -nonmax_suppress 0 -min_dist 1 -aseg /out/freesurfer/sub-THP0005/mri/aseg.presurf.mgz -surface /out/freesurfer/sub-THP0005/surf/rh.white identity.nofile -surface /out/freesurfer/sub-THP0005/surf/lh.white identity.nofile /out/freesurfer/sub-THP0005/mri/T2.prenorm.mgz /out/freesurfer/sub-THP0005/mri/T2.norm.mgz 


 cp /out/freesurfer/sub-THP0005/mri/transforms/T2raw.auto.lta /out/freesurfer/sub-THP0005/mri/transforms/T2raw.lta 


 mri_convert -odt float -at /out/freesurfer/sub-THP0005/mri/transforms/T2raw.lta -rl /out/freesurfer/sub-THP0005/mri/orig.mgz /out/freesurfer/sub-THP0005/mri/orig/T2raw.mgz /out/freesurfer/sub-THP0005/mri/T2.prenorm.mgz 


 mri_normalize -sigma 0.5 -nonmax_suppress 0 -min_dist 1 -aseg /out/freesurfer/sub-THP0005/mri/aseg.presurf.mgz -surface /out/freesurfer/sub-THP0005/surf/rh.white identity.nofile -surface /out/freesurfer/sub-THP0005/surf/lh.white identity.nofile /out/freesurfer/sub-THP0005/mri/T2.prenorm.mgz /out/freesurfer/sub-THP0005/mri/T2.norm.mgz 


 mri_mask /out/freesurfer/sub-THP0005/mri/T2.norm.mgz /out/freesurfer/sub-THP0005/mri/brainmask.mgz /out/freesurfer/sub-THP0005/mri/T2.mgz 


 mri_mask /out/freesurfer/sub-THP0005/mri/T2.norm.mgz /out/freesurfer/sub-THP0005/mri/brainmask.mgz /out/freesurfer/sub-THP0005/mri/T2.mgz 


 cp -v /out/freesurfer/sub-THP0005/surf/lh.pial /out/freesurfer/sub-THP0005/surf/lh.woT2.pial 


 mris_make_surfaces -orig_white white -orig_pial woT2.pial -aseg ../mri/aseg.presurf -nowhite -mgz -T1 brain.finalsurfs -T2 ../mri/T2 -nsigma_above 2 -nsigma_below 5 sub-THP0005 lh 


 cp -v /out/freesurfer/sub-THP0005/surf/rh.pial /out/freesurfer/sub-THP0005/surf/rh.woT2.pial 


 mris_make_surfaces -orig_white white -orig_pial woT2.pial -aseg ../mri/aseg.presurf -nowhite -mgz -T1 brain.finalsurfs -T2 ../mri/T2 -nsigma_above 2 -nsigma_below 5 sub-THP0005 rh 

#--------------------------------------------
#@# Surf Volume rh Sat Sep 14 03:05:23 UTC 2019

 vertexvol --s sub-THP0005 --rh --th3 

#--------------------------------------------
#@# Surf Volume rh Sat Sep 14 03:05:27 UTC 2019
#--------------------------------------------
#@# Cortical ribbon mask Sat Sep 14 03:05:31 UTC 2019

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-THP0005 

#--------------------------------------------
#@# Surf Volume lh Sat Sep 14 03:08:38 UTC 2019

 vertexvol --s sub-THP0005 --lh --th3 

#--------------------------------------------
#@# Surf Volume lh Sat Sep 14 03:08:41 UTC 2019
#--------------------------------------------
#@# Cortical ribbon mask Sat Sep 14 03:08:45 UTC 2019

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-THP0005 

#-----------------------------------------
#@# Parcellation Stats rh Sat Sep 14 03:11:02 UTC 2019

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-THP0005 rh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-THP0005 rh pial 

#-----------------------------------------
#@# Cortical Parc 2 rh Sat Sep 14 03:11:52 UTC 2019

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-THP0005 rh ../surf/rh.sphere.reg /opt/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 rh Sat Sep 14 03:12:06 UTC 2019

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-THP0005 rh white 

#-----------------------------------------
#@# Cortical Parc 3 rh Sat Sep 14 03:12:33 UTC 2019

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-THP0005 rh ../surf/rh.sphere.reg /opt/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Parcellation Stats 3 rh Sat Sep 14 03:12:45 UTC 2019

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-THP0005 rh white 

#-----------------------------------------
#@# WM/GM Contrast rh Sat Sep 14 03:13:12 UTC 2019

 pctsurfcon --s sub-THP0005 --rh-only 

#-----------------------------------------
#@# Relabel Hypointensities Sat Sep 14 03:13:19 UTC 2019

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# AParc-to-ASeg aparc Sat Sep 14 03:13:35 UTC 2019

 mri_aparc2aseg --s sub-THP0005 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt 

#-----------------------------------------
#@# Parcellation Stats lh Sat Sep 14 03:14:05 UTC 2019

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-THP0005 lh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-THP0005 lh pial 

#-----------------------------------------
#@# Cortical Parc 2 lh Sat Sep 14 03:14:54 UTC 2019

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-THP0005 lh ../surf/lh.sphere.reg /opt/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 lh Sat Sep 14 03:15:07 UTC 2019

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-THP0005 lh white 

#-----------------------------------------
#@# Cortical Parc 3 lh Sat Sep 14 03:15:33 UTC 2019

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-THP0005 lh ../surf/lh.sphere.reg /opt/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Parcellation Stats 3 lh Sat Sep 14 03:15:44 UTC 2019

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-THP0005 lh white 

#-----------------------------------------
#@# WM/GM Contrast lh Sat Sep 14 03:16:08 UTC 2019

 pctsurfcon --s sub-THP0005 --lh-only 

#-----------------------------------------
#@# Relabel Hypointensities Sat Sep 14 03:16:14 UTC 2019

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# AParc-to-ASeg aparc Sat Sep 14 03:16:30 UTC 2019

 mri_aparc2aseg --s sub-THP0005 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt 

#-----------------------------------------
#@# AParc-to-ASeg a2009s Sat Sep 14 03:16:53 UTC 2019

 mri_aparc2aseg --s sub-THP0005 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s 

#-----------------------------------------
#@# AParc-to-ASeg a2009s Sat Sep 14 03:19:52 UTC 2019

 mri_aparc2aseg --s sub-THP0005 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s 

#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Sat Sep 14 03:20:17 UTC 2019

 mri_aparc2aseg --s sub-THP0005 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz 

#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Sat Sep 14 03:23:15 UTC 2019

 mri_aparc2aseg --s sub-THP0005 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz 

#-----------------------------------------
#@# APas-to-ASeg Sat Sep 14 03:23:36 UTC 2019

 apas2aseg --i aparc+aseg.mgz --o aseg.mgz 

#--------------------------------------------
#@# ASeg Stats Sat Sep 14 03:23:42 UTC 2019

 mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /opt/freesurfer/ASegStatsLUT.txt --subject sub-THP0005 

#-----------------------------------------
#@# WMParc Sat Sep 14 03:24:13 UTC 2019

 mri_aparc2aseg --s sub-THP0005 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz 


 mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-THP0005 --surf-wm-vol --ctab /opt/freesurfer/WMParcStatsLUT.txt --etiv 

#-----------------------------------------
#@# APas-to-ASeg Sat Sep 14 03:26:41 UTC 2019

 apas2aseg --i aparc+aseg.mgz --o aseg.mgz 

#--------------------------------------------
#@# ASeg Stats Sat Sep 14 03:26:47 UTC 2019

 mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /opt/freesurfer/ASegStatsLUT.txt --subject sub-THP0005 

#-----------------------------------------
#@# WMParc Sat Sep 14 03:27:20 UTC 2019

 mri_aparc2aseg --s sub-THP0005 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz 

#--------------------------------------------
#@# BA_exvivo Labels rh Sat Sep 14 03:29:30 UTC 2019

 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface 


 mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-THP0005 --surf-wm-vol --ctab /opt/freesurfer/WMParcStatsLUT.txt --etiv 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-THP0005 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface 

#--------------------------------------------
#@# BA_exvivo Labels lh Sat Sep 14 03:33:03 UTC 2019

 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface 


 mris_label2annot --s sub-THP0005 --hemi rh --ctab /opt/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-THP0005 --hemi rh --ctab /opt/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-THP0005 rh white 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-THP0005 rh white 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-THP0005 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /out/freesurfer/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-THP0005 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s sub-THP0005 --hemi lh --ctab /opt/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-THP0005 --hemi lh --ctab /opt/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-THP0005 lh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-THP0005 lh white 

