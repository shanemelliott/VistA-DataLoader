ISIFXWT ;Fix WEIGHT rates in file 120.5 saved with a unit suffix (185L, 191lb, 80K)
 ;;3.1;VISTA DATALOADER;;Nov 23, 2026
 ;
 ; D EN^ISIFXWT(0) lists the entries only; D EN^ISIFXWT(1) rewrites field 1.2 as a plain number of pounds.
 Q
 ;
EN(APPLY) ;
 N IEN,Z,RT,NEW,CNT,FIX,FDA,ERR
 S (IEN,CNT,FIX)=0
 F  S IEN=$O(^GMR(120.5,IEN)) Q:'IEN  D
 . S Z=$G(^GMR(120.5,IEN,0))
 . Q:$P($G(^GMRD(120.51,+$P(Z,U,3),0)),U)'="WEIGHT"
 . S RT=$P(Z,U,8)
 . Q:RT=""
 . Q:RT?1.N.1".".N
 . S NEW=$$NORMWT^ISIIMP09(RT)
 . S CNT=CNT+1
 . W !,IEN," DFN ",$P(Z,U,2)," ",$$FMTE^XLFDT($P(Z,U,1),"2P")," ",RT," -> ",NEW," ",$P($G(^VA(200,+$P(Z,U,6),0)),U)
 . Q:'$G(APPLY)
 . K FDA,ERR
 . S FDA(120.5,IEN_",",1.2)=NEW
 . D FILE^DIE("","FDA","ERR")
 . I $D(ERR) W "  ERROR" Q
 . S FIX=FIX+1
 W !,CNT," weights with a unit suffix; ",FIX," fixed"
 Q
