MODULE MainModule
	TASK PERS tooldata T_valvula:=[TRUE,[[-21.3786,-23.6601,76.4411],[1,0,0,0]],[1,[0.1,0,0],[1,0,0,0],0,0,0]];
	CONST robtarget pos_coger_espera:=[[-148.67,-334.09,237.40],[0.0221112,0.379172,-0.925061,-0.0013214],[-2,-1,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget home:=[[422.57,-15.04,314.73],[0.0220878,0.379122,-0.925082,-0.00129255],[-1,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget eje_camara:=[[-164.60,-346.85,129.74],[0.0221252,0.379112,-0.925085,-0.00127603],[-2,-1,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget posicionar_cinta:=[[265.64,-329.96,237.40],[0.0221105,0.379148,-0.925071,-0.00130637],[-1,-1,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget dejar_verdes:=[[508.53,222.10,27.27],[0.0218995,0.379168,-0.925068,-0.00125911],[0,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget dejar_rojas:=[[513.40,18.32,26.73],[0.0217502,0.37925,-0.925038,-0.00111166],[0,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget dejar_5_rojas:=[[478.69,-19.33,62.78],[0.022107,0.379084,-0.925097,-0.00128542],[-1,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget dejar_5_verdes:=[[478.68,184.10,62.77],[0.0221189,0.379096,-0.925092,-0.00128612],[0,0,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !Change the job name
    CONST string myjob := "vision_26042022";
    VAR cameratarget mycameratarget;
    VAR num offs_pieza;
    VAR num estado_cam;
    VAR num piezas_rojas;
    VAR num piezas_verdes;
    VAR num offset_dejar_rojas_y;
    VAR num offset_dejar_rojas_x;
    VAR num offset_dejar_verdes_y;
    VAR num offset_dejar_verdes_x;



       
    PROC main()

        IF estado_cam < 1 THEN !PONER EN MARCHA LA CÁMARA
            CamSetProgramMode VISION_TELLEZ;
            CamLoadJob VISION_TELLEZ, myjob;
            CamSetRunMode VISION_TELLEZ; 
            estado_cam := 1;
        ENDIF !MARCHA CÁMARA
      
        MoveJ home,v300,z0,T_valvula\WObj:=wobj0;
    
        IF piezas_rojas = 5 AND piezas_verdes = 5 THEN !INICIO PREGUNTAS
           TPReadNum reg1,"¿QUIERE EJECUTAR OTRA VEZ EL PROCESO? 1= SI / 2= NO"; !PRIMERA PREGUNTA PROCESO
           TPWrite"  ";
           IF reg1 = 1 THEN !RESPUESTA 1 SEGUIR PROCESO
               TPReadNum reg2,"¿Ha recogido las piezas de la zona de colocación? 1= SI / 2= NO"; !SEGUNDA PREGUNTA PIEZA A
               TPWrite"  ";
                IF reg2 = 1 THEN !RESPUESTA 1 PIEZAS A
                    TPWrite "Iniciando proceso...";
                    TPWrite"3...";
                    WaitTime 1;
                    TPWrite"2...";
                    WaitTime 1;
                    TPWrite"1...";
                    WaitTime 1;
                    TPErase;
                    piezas_verdes := 0;
                    piezas_rojas := 0;
                ELSEIF reg2 = 2 THEN !RESPUESTA 2 PIEZAS A
                    TPReadNum reg3,"¿Has terminado de recoger las piezas? 1= SI / 2= NO"; !TERCERA PREGUNTA PIEZA B
                    IF reg3 = 1 THEN
                        TPWrite "Iniciando proceso...";!RESPUESTA 1 PIEZAS B
                        TPWrite"3...";
                        WaitTime 1;
                        TPWrite"2...";
                        WaitTime 1;
                        TPWrite"1...";
                        WaitTime 1;
                        TPErase;
                        piezas_verdes := 0;
                        piezas_rojas := 0;
                    ELSEIF reg3 = 2 THEN
                        TPWrite "Cancelando proceso...";!RESPUESTA 2 PIEZAS B
                        piezas_verdes := 0;
                        piezas_rojas := 0;
                        TPWrite"5...";
                        WaitTime 1;
                        TPWrite"4...";
                        WaitTime 1;
                        TPWrite"3...";
                        WaitTime 1;
                        TPWrite"2...";
                        WaitTime 1;
                        TPWrite"1...";
                        WaitTime 1;
                        TPErase;
                        Break; 
                    ELSE
                    ENDIF
                ENDIF
           ELSE !RESPUES 2 SEGUIR PROCESO
            TPWrite "Hasta la proxima...";
            piezas_verdes := 0;
            piezas_rojas := 0;
            WaitTime 5;
            TPErase;
            Break;
           ENDIF
        ENDIF !FIN PREGUNTAS
        
        TPWrite "INICIANDO LECTURA DE LA PIEZA";
        
        CamReqImage VISION_TELLEZ;
        CamGetResult VISION_TELLEZ, mycameratarget \MaxTime:=20;
            
            MoveJ posicionar_cinta,v1000,z200,T_valvula\WObj:=wobj0;
            MoveJ pos_coger_espera,v1000,fine,T_valvula\WObj:=wobj0;
            TPWrite "MOVIENDO HACIA RECOGIDA DE PIEZA";
                  
                !inicio rojas 
                IF mycameratarget.string1 = "ROJO" THEN
                       
                    IF mycameratarget.val2 = 50 THEN !piezas redondas rojas
                        TPWrite "ES UNA PIEZA REDONDA ROJA";
                        IF mycameratarget.val1 > 50 THEN !medimos el valor de medicion
                        
                            offs_pieza := mycameratarget.cframe.trans.y; !cogemos pieza en cinta            
                            IF offs_pieza < 0 THEN
                                offs_pieza := abs(offs_pieza);
                            ELSE IF offs_pieza > 0
                                offs_pieza := 0 - offs_pieza;
                            ENDIF
                            MoveL offs (eje_camara,0,offs_pieza,40),v100,fine,T_valvula\WObj:=wobj0;
                            MoveLdo offs (eje_camara,0,offs_pieza,-0.7),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,1;
                            WaitTime 0.5;
                            TPWrite "PIEZA REDONDA ROJA CAPTURADA";
                            MoveL offs (eje_camara,0,offs_pieza,40),v100,fine,T_valvula\WObj:=wobj0;
                        ENDIF
                        !ya hemos cogido la pieza de la cinta 
                        MoveJ posicionar_cinta,v1000,z200,T_valvula\WObj:=wobj0;
                        TPWrite "MOVIMIENTO HACIA LUGAR DE DEPOSITO DE PIEZA";
                        !iniciamos paletizacion de las piezas redondas rojas
                        IF piezas_rojas  <=1 THEN
                            MoveL offs (dejar_rojas,offset_dejar_rojas_x,offset_dejar_rojas_y,40),v500,z0,T_valvula\WObj:=wobj0;
                            MoveLDO offs (dejar_rojas,offset_dejar_rojas_x,offset_dejar_rojas_y,-0.5),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,0;
                            WaitTime 1;
                            MoveL offs (dejar_rojas,offset_dejar_rojas_x,offset_dejar_rojas_y,40),v200,z0,T_valvula\WObj:=wobj0;
                            offset_dejar_rojas_y := -75; 
                            TPWrite "PIEZA DEPOSITADA";
                        ENDIF
                        IF piezas_rojas  = 2 or piezas_rojas  = 3 THEN
                            offset_dejar_rojas_x := -70;
                            MoveL offs (dejar_rojas,offset_dejar_rojas_x,offset_dejar_rojas_y,40),v500,z0,T_valvula\WObj:=wobj0;
                            MoveLDO offs (dejar_rojas,offset_dejar_rojas_x,offset_dejar_rojas_y,-0.5),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,0;
                            WaitTime 1;
                            MoveL offs (dejar_rojas,offset_dejar_rojas_x,offset_dejar_rojas_y,40),v200,z0,T_valvula\WObj:=wobj0;
                            offset_dejar_rojas_y := -75;
                            TPWrite "PIEZA DEPOSITADA";
                        ENDIF
                        IF piezas_rojas = 4 THEN
                            MoveL offs (dejar_5_rojas,0,0,40),v500,z0,T_valvula\WObj:=wobj0;
                            MoveLDO offs (dejar_5_rojas,0,0,0),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,0;
                            WaitTime 1;
                            MoveL offs (dejar_5_rojas,0,0,40),v200,z0,T_valvula\WObj:=wobj0;
                            TPWrite "PIEZA DEPOSITADA";
                        ENDIF
                        
                        piezas_rojas  := piezas_rojas  + 1; !sumamos 1 en el palet hasta un total de 5
                        IF piezas_rojas  = 2 THEN
                            offset_dejar_rojas_y := 0;
                        ENDIF
                        IF piezas_rojas  = 5 THEN
                            offset_dejar_rojas_y := 0;
                            offset_dejar_rojas_x := 0;
                            !ya se han paletizado 5 piezas
                        ENDIF
                        TPWrite "MOVIENDO A HOME";
                        MoveJ home,v300,fine,T_valvula\WObj:=wobj0; 
                        TPErase;
                    ENDIF !fin piezas redondas rojas
                        
                        
                    IF mycameratarget.val2 = 49 THEN ! piezas cuadradas rojas 
                        TPWrite "ES UNA PIEZA CUADRADA ROJA";
                        IF mycameratarget.val1 > 50 THEN !comprobamos estado medicion 
                        
                        Offs_pieza := mycameratarget.cframe.trans.y; !cogemos pieza en cinta
                        IF offs_pieza < 0 THEN
                            offs_pieza := abs(offs_pieza);
                        ELSE IF offs_pieza > 0
                            offs_pieza := 0 - offs_pieza;
                        ENDIF
                        MoveL offs (eje_camara,0,offs_pieza,40),v100,fine,T_valvula\WObj:=wobj0;
                        MoveLdo offs (eje_camara,0,offs_pieza,-0.4),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,1;
                        WaitTime 0.5;
                        TPWrite "PIEZA CUADRADA ROJA CAPTURADA";
                        MoveL offs (eje_camara,0,offs_pieza,40),v100,fine,T_valvula\WObj:=wobj0;
                        ENDIF
                        !ya hemos cogido la pieza de la cinta
                        MoveJ posicionar_cinta,v1000,z200,T_valvula\WObj:=wobj0;
                        TPWrite "MOVIMIENTO HACIA LUGAR DE DEPOSITO DE PIEZA";
                        !iniciamos paletizacion de las piezas cuadradas rojas
                        IF piezas_rojas  <=1 THEN          
                            MoveL offs (dejar_rojas,offset_dejar_rojas_x,offset_dejar_rojas_y,40),v500,z0,T_valvula\WObj:=wobj0;
                            MoveLDO offs (dejar_rojas,offset_dejar_rojas_x,offset_dejar_rojas_y,-0.5),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,0;
                            WaitTime 1;
                            MoveL offs (dejar_rojas,offset_dejar_rojas_x,offset_dejar_rojas_y,40),v200,z0,T_valvula\WObj:=wobj0;
                            offset_dejar_rojas_y := -75; 
                            TPWrite "PIEZA DEPOSITADA";
                        ENDIF
                        IF piezas_rojas  = 2 or piezas_rojas  = 3 THEN
                            offset_dejar_rojas_x := -70;
                            MoveL offs (dejar_rojas,offset_dejar_rojas_x,offset_dejar_rojas_y,40),v500,z0,T_valvula\WObj:=wobj0;
                            MoveLDO offs (dejar_rojas,offset_dejar_rojas_x,offset_dejar_rojas_y,-0.5),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,0;
                            WaitTime 1;
                            MoveL offs (dejar_rojas,offset_dejar_rojas_x,offset_dejar_rojas_y,40),v200,z0,T_valvula\WObj:=wobj0;
                            offset_dejar_rojas_y := -75;
                            TPWrite "PIEZA DEPOSITADA";
                        ENDIF
                        IF piezas_rojas = 4 THEN
                            MoveL offs (dejar_5_rojas,0,0,40),v500,z0,T_valvula\WObj:=wobj0;
                            MoveLDO offs (dejar_5_rojas,0,0,0),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,0;
                            WaitTime 1;
                            MoveL offs (dejar_5_rojas,0,0,40),v200,z0,T_valvula\WObj:=wobj0;
                            TPWrite "PIEZA DEPOSITADA";
                        ENDIF
                        
                        piezas_rojas  := piezas_rojas  + 1; !sumamos 1 en el palet hasta un total de 5
                        IF piezas_rojas  = 2 THEN
                            offset_dejar_rojas_y := 0;
                        ENDIF
                        IF piezas_rojas  = 5 THEN
                            offset_dejar_rojas_y := 0;
                            offset_dejar_rojas_x := 0;
                            !ya se han paletizado 5 piezas
                        ENDIF
                        TPWrite "MOVIENDO A HOME";
                        MoveJ home,v300,fine,T_valvula\WObj:=wobj0; 
                        TPErase;
                        
                    ENDIF !fin cajas cuadradas rojas
                    
                ENDIF !fin rojas
        
                !inicio verde
                IF mycameratarget.string1 = "VERDE" THEN
                       
                    IF mycameratarget.val2 = 50 THEN !piezas redondas verde
                        TPWrite "ES UNA PIEZA REDONDA VERDE";
                        IF mycameratarget.val1 > 50 THEN !medimos el valor de medicion
                        
                            offs_pieza := mycameratarget.cframe.trans.y; !cogemos pieza en cinta            
                            IF offs_pieza < 0 THEN
                                offs_pieza := abs(offs_pieza);
                            ELSE IF offs_pieza > 0
                                offs_pieza := 0 - offs_pieza;
                            ENDIF
                            MoveL offs (eje_camara,0,offs_pieza,40),v100,fine,T_valvula\WObj:=wobj0;
                            MoveLdo offs (eje_camara,0,offs_pieza,-0.7),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,1;
                            WaitTime 0.5;
                            TPWrite "PIEZA REDONDA VERDE CAPTURADA";
                            MoveL offs (eje_camara,0,offs_pieza,40),v100,fine,T_valvula\WObj:=wobj0;
                        ENDIF
                        !ya hemos cogido la pieza de la cinta 
                        MoveJ posicionar_cinta,v1000,z200,T_valvula\WObj:=wobj0;
                        TPWrite "MOVIENDO HACIA LUGAR DE DEPOSITO DE PIEZA";
                        !iniciamos paletizacion de las piezas redondas verde
                        IF piezas_verdes  <=1 THEN          
                            MoveL offs (dejar_verdes,offset_dejar_verdes_x,offset_dejar_verdes_y,40),v500,z0,T_valvula\WObj:=wobj0;
                            MoveLDO offs (dejar_verdes,offset_dejar_verdes_x,offset_dejar_verdes_y,-0.5),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,0;
                            WaitTime 1;
                            MoveL offs (dejar_verdes,offset_dejar_verdes_x,offset_dejar_verdes_y,40),v500,z0,T_valvula\WObj:=wobj0;
                            offset_dejar_verdes_y := -75; 
                            TPWrite "PIEZA DEPOSITADA";
                        ENDIF
                        IF piezas_verdes  = 2 or piezas_verdes  = 3 THEN
                            offset_dejar_verdes_x := -70;
                            MoveL offs (dejar_verdes,offset_dejar_verdes_x,offset_dejar_verdes_y,40),v500,z0,T_valvula\WObj:=wobj0;
                            MoveLDO offs (dejar_verdes,offset_dejar_verdes_x,offset_dejar_verdes_y,-0.5),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,0;
                            WaitTime 1;
                            MoveL offs (dejar_verdes,offset_dejar_verdes_x,offset_dejar_verdes_y,40),v200,z0,T_valvula\WObj:=wobj0;
                            offset_dejar_verdes_y := -75; 
                            TPWrite "PIEZA DEPOSITADA";
                        ENDIF
                        IF piezas_verdes = 4 THEN
                            MoveL offs (dejar_5_verdes,0,0,40),v500,z0,T_valvula\WObj:=wobj0;
                            MoveLDO offs (dejar_5_verdes,0,0,0),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,0;
                            WaitTime 1;
                            MoveL offs (dejar_5_verdes,0,0,40),v200,z0,T_valvula\WObj:=wobj0;
                            TPWrite "PIEZA DEPOSITADA";
                        ENDIF
                        
                        piezas_verdes  := piezas_verdes  + 1; !sumamos 1 en el palet hasta un total de 5
                        IF piezas_verdes  = 2 THEN
                            offset_dejar_verdes_y := 0;
                        ENDIF
                        IF piezas_verdes  = 5 THEN
                            offset_dejar_verdes_y := 0;
                            offset_dejar_verdes_x := 0;
                            !ya se han paletizado 5 piezas
                        ENDIF
                        TPWrite "MOVIENDO A HOME";
                        MoveJ home,v300,fine,T_valvula\WObj:=wobj0; 
                        TPErase;
                    ENDIF !fin piezas redondas verde
                        
                        
                    IF mycameratarget.val2 = 49 THEN ! piezas cuadradas verde 
                        TPWrite "ES UNA PIEZA CUADRADA VERDE";
                        IF mycameratarget.val1 > 50 THEN !comprobamos estado medicion 
                        
                        Offs_pieza := mycameratarget.cframe.trans.y; !cogemos pieza en cinta
                        IF offs_pieza < 0 THEN
                            offs_pieza := abs(offs_pieza);
                        ELSE IF offs_pieza > 0
                            offs_pieza := 0 - offs_pieza;
                        ENDIF
                        MoveL offs (eje_camara,0,offs_pieza,40),v100,fine,T_valvula\WObj:=wobj0;
                        MoveLdo offs (eje_camara,0,offs_pieza,-0.4),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,1;
                        WaitTime 0.5;
                        TPWrite "PIEZA CUADRADA VERDE CAPTURADA";
                        MoveL offs (eje_camara,0,offs_pieza,40),v100,fine,T_valvula\WObj:=wobj0;
                        ENDIF
                        !ya hemos cogido la pieza de la cinta
                        MoveJ posicionar_cinta,v1000,z200,T_valvula\WObj:=wobj0;
                        TPWrite "MOVIENDO HACIA LUGAR DE DEPOSITO DE PIEZA";
                        !iniciamos paletizacion de las piezas cuadradas verde
                        IF piezas_verdes  <=1 THEN          
                            MoveL offs (dejar_verdes,offset_dejar_verdes_x,offset_dejar_verdes_y,40),v500,z0,T_valvula\WObj:=wobj0;
                            MoveLDO offs (dejar_verdes,offset_dejar_verdes_x,offset_dejar_verdes_y,-0.5),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,0;
                            WaitTime 1;
                            MoveL offs (dejar_verdes,offset_dejar_verdes_x,offset_dejar_verdes_y,40),v200,z0,T_valvula\WObj:=wobj0;
                            offset_dejar_verdes_y := -75;
                            TPWrite "PIEZA DEPOSITADA";
                        ENDIF
                        IF piezas_verdes  = 2 or piezas_verdes  = 3 THEN
                            offset_dejar_verdes_x := -70;
                            MoveL offs (dejar_verdes,offset_dejar_verdes_x,offset_dejar_verdes_y,40),v500,z0,T_valvula\WObj:=wobj0;
                            MoveLDO offs (dejar_verdes,offset_dejar_verdes_x,offset_dejar_verdes_y,-0.5),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,0;
                            WaitTime 1;
                            MoveL offs (dejar_verdes,offset_dejar_verdes_x,offset_dejar_verdes_y,40),v200,z0,T_valvula\WObj:=wobj0;
                            offset_dejar_verdes_y := -75;
                            TPWrite "PIEZA DEPOSITADA";
                        ENDIF
                        IF piezas_verdes = 4 THEN
                            MoveL offs (dejar_5_verdes,0,0,40),v500,z0,T_valvula\WObj:=wobj0;
                            MoveLDO offs (dejar_5_verdes,0,0,0),v50,fine,T_valvula\WObj:=wobj0,do7_DSQC652,0;
                            WaitTime 1;
                            MoveL offs (dejar_5_verdes,0,0,40),v200,z0,T_valvula\WObj:=wobj0;
                            TPWrite "PIEZA DEPOSITADA";
                        ENDIF
                        
                        piezas_verdes  := piezas_verdes  + 1; !sumamos 1 en el palet hasta un total de 5
                        IF piezas_verdes  = 2 THEN
                            offset_dejar_verdes_y := 0;
                        ENDIF
                        IF piezas_verdes  = 5 THEN
                            offset_dejar_verdes_y := 0;
                            offset_dejar_verdes_x := 0;
                            !ya se han paletizado 5 piezas
                        ENDIF
                        TPWrite "MOVIENDO A HOME";
                        MoveJ home,v300,fine,T_valvula\WObj:=wobj0; 
                        TPErase;
                    ENDIF !fin cajas cuadradas verde
                    
                ENDIF !fin VERDES
                

    ENDPROC 
  
         
ENDMODULE