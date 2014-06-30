clc;
clear;
conn = database('','','','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://192.168.1.34:1433;database=GazTurbin;integratedSecurity=true;');
ping(conn);
gg = 'select top 10 [Naryan_mar_GTS_Naryan_mar_GTS.A1_alarm_a].value  from [Naryan_mar_GTS_Naryan_mar_GTS.A1_alarm_a] where [Naryan_mar_GTS_Naryan_mar_GTS.A1_alarm_a].param = ''BL0100'''
curs = exec(conn, 'select top 10 [Naryan_mar_GTS_Naryan_mar_GTS.A1_alarm_a].value  from [Naryan_mar_GTS_Naryan_mar_GTS.A1_alarm_a] where [Naryan_mar_GTS_Naryan_mar_GTS.A1_alarm_a].param = ''BL0100''');
setdbprefs('DataReturnFormat','cellarray');
curs = fetch(curs, 10);
AA = curs.Data;
close(curs);
close(conn);