ISIFXLN ;Re-stamp the LOINC on old HEMOGLOBIN A1C (4637-5 to 4548-4) and uACR (none to 9318-7) results
 ;;3.1;VISTA DATALOADER;;Nov 23, 2026
 ;
 ; D EN^ISIFXLN(0) lists the results only; D EN^ISIFXLN(1) changes them.
 ; The VPR reads the LOINC from the result: $P($P(^LR(LRDFN,"CH",IDT,DN),U,3),"!",3) is a pointer to file 95.3.
 ; Old piece 3 values are kept in ^XTMP("ISIFXLN",LRDFN,IDT,DN) for 30 days.
 Q
 ;
EN(APPLY) ;
 N A1C,UAC,OLD,NEWA,NEWU,DNA,DNU,LRDFN,IDT,CNT,FIX
 S A1C=$$TEST("HEMOGLOBIN A1C"),UAC=$$TEST("Microalbumin/Creatinine Ratio")
 S OLD=$$LNC("4637-5"),NEWA=$$LNC("4548-4"),NEWU=$$LNC("9318-7")
 I 'A1C!('UAC)!('OLD)!('NEWA)!('NEWU) W !,"Lab test or LOINC entry not found; nothing done." Q
 S DNA=$$DN(A1C),DNU=$$DN(UAC)
 I 'DNA!('DNU) W !,"Data name not found; nothing done." Q
 W !,"A1C test ",A1C," data name ",DNA,"; uACR test ",UAC," data name ",DNU
 I $G(APPLY) S ^XTMP("ISIFXLN",0)=$$FMADD^XLFDT($$DT^XLFDT,30)_U_$$DT^XLFDT_U_"ISIFXLN LOINC re-stamp backup"
 S (LRDFN,CNT,FIX)=0
 F  S LRDFN=$O(^LR(LRDFN)) Q:'LRDFN  D
 . S IDT=0
 . F  S IDT=$O(^LR(LRDFN,"CH",IDT)) Q:'IDT  D
 .. I $D(^LR(LRDFN,"CH",IDT,DNA))#2 D RES(DNA,OLD,NEWA)
 .. I $D(^LR(LRDFN,"CH",IDT,DNU))#2 D RES(DNU,"",NEWU)
 W !,CNT," results to re-stamp; ",FIX," changed"
 Q
 ;
RES(DN,FROM,TO) ;
 N Z,P3,CUR
 S Z=$G(^LR(LRDFN,"CH",IDT,DN)),P3=$P(Z,U,3),CUR=+$P(P3,"!",3)
 Q:CUR=TO
 Q:FROM&(CUR'=FROM)
 S CNT=CNT+1
 W !,"LRDFN ",LRDFN," DFN ",$P($G(^LR(LRDFN,0)),U,3)," ",$$FMTE^XLFDT(9999999-IDT,"2P")," ",$P(Z,U)," ",$S(CUR:$$GET1^DIQ(95.3,CUR_",",.01),1:"none")," -> ",$$GET1^DIQ(95.3,TO_",",.01)
 Q:'$G(APPLY)
 S ^XTMP("ISIFXLN",LRDFN,IDT,DN)=P3
 S $P(P3,"!",3)=TO
 S $P(^LR(LRDFN,"CH",IDT,DN),U,3)=P3
 S FIX=FIX+1
 Q
 ;
TEST(NAME) Q +$O(^LAB(60,"B",NAME,0))
 ;
DN(T) Q +$P($P($G(^LAB(60,T,0)),U,5),";",2)
 ;
LNC(CODE) ;IEN in file 95.3 whose external code is CODE (e.g. 4548-4), or 0
 N I,K,X
 S X=0
 F K=+CODE,CODE D  Q:X
 . S I=0
 . F  S I=$O(^LAB(95.3,"B",K,I)) Q:'I  I $$GET1^DIQ(95.3,I_",",.01)=CODE S X=I Q
 Q X
