<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1474282383312" ID="ID_604751849" MODIFIED="1474282393579" TEXT="EZADMIN">
<node CREATED="1474282394123" ID="ID_1744521902" MODIFIED="1474282395411" POSITION="right" TEXT="Bugs">
<node CREATED="1474282396039" ID="ID_1691938579" MODIFIED="1474282401587" TEXT="os detection">
<node CREATED="1474282402171" ID="ID_985353037" MODIFIED="1474282742096" TEXT="Fix Arch Linux support">
<icon BUILTIN="full-3"/>
</node>
<node CREATED="1474282414385" ID="ID_477746426" MODIFIED="1474282418179" TEXT="Fix Centos">
<node CREATED="1474282418767" ID="ID_1707753654" MODIFIED="1474282737583" TEXT="6">
<icon BUILTIN="full-1"/>
</node>
<node CREATED="1474282420736" ID="ID_260989011" MODIFIED="1474282739752" TEXT="5">
<icon BUILTIN="full-2"/>
</node>
</node>
</node>
<node CREATED="1476191642635" ID="ID_1625595882" MODIFIED="1476191648897" TEXT="site migrator">
<node CREATED="1476191829788" ID="ID_1362491454" MODIFIED="1476191953568" TEXT="file migration">
<node CREATED="1476191649427" ID="ID_1313886154" MODIFIED="1476191679257" TEXT="assumes that the site files are stored in a htdocs folder in the home directory on the remote server">
<node CREATED="1476191684882" ID="ID_31694372" MODIFIED="1476191695558" TEXT="need to make this specifyable via option"/>
</node>
<node CREATED="1476191839500" ID="ID_36463281" MODIFIED="1476191873429" TEXT="currently copies to a directory and then copies contents of the htdocs subdirectory of that directory to the public html of the subscription">
<node CREATED="1476191874036" ID="ID_1322372347" MODIFIED="1476191881562" TEXT="need to modify to">
<node CREATED="1476191882092" ID="ID_576984224" MODIFIED="1476191910346" TEXT="provide option to just copy htdocs directly to the subscription&apos;s htdocs"/>
</node>
</node>
<node CREATED="1476192148902" ID="ID_417365069" MODIFIED="1476192159138" TEXT="need to provide option to not perform file migration"/>
<node CREATED="1476192432240" ID="ID_978660126" MODIFIED="1476192435250" TEXT="file migration modes">
<node CREATED="1476192435864" ID="ID_203785628" MODIFIED="1476192437162" TEXT="rsync">
<node CREATED="1476192452808" ID="ID_524657014" MODIFIED="1476192457739" TEXT="need to implement">
<node CREATED="1476192459608" ID="ID_1643266391" MODIFIED="1476192461875" TEXT="preferred"/>
</node>
</node>
<node CREATED="1476192437447" ID="ID_836212270" MODIFIED="1476192438835" TEXT="tarsync"/>
<node CREATED="1476192439054" ID="ID_1363764720" MODIFIED="1476192440483" TEXT="ftp">
<node CREATED="1476192448048" ID="ID_524863809" MODIFIED="1476192451546" TEXT="need to implement"/>
</node>
</node>
</node>
<node CREATED="1476191954220" ID="ID_865395388" MODIFIED="1476191956657" TEXT="database migration">
<node CREATED="1476192070328" ID="ID_934379755" MODIFIED="1476192110117" TEXT="need to provide options to provide remote mysql login details"/>
<node CREATED="1476192119934" ID="ID_1772390844" MODIFIED="1476192127840" TEXT="need to provide option to import from sql file"/>
<node CREATED="1476192134959" ID="ID_880845607" MODIFIED="1476192146625" TEXT="need to provide option to not import database"/>
</node>
<node CREATED="1476191976847" ID="ID_1112955191" MODIFIED="1476191981362" TEXT="cms detection">
<node CREATED="1476191982316" ID="ID_1559629139" MODIFIED="1476191984512" TEXT="wordpress"/>
<node CREATED="1476191984892" ID="ID_1771107825" MODIFIED="1476191989385" TEXT="magento"/>
</node>
</node>
<node CREATED="1474283499383" ID="ID_1638724552" MODIFIED="1474283503291" TEXT="docs">
<node CREATED="1474283503871" ID="ID_233969434" MODIFIED="1474283514117" TEXT="mention how to modularise the scripts properly">
<node CREATED="1474283515743" ID="ID_1568532609" MODIFIED="1474283518394" TEXT="includes folder"/>
<node CREATED="1474283525848" ID="ID_933815963" MODIFIED="1474283527987" TEXT="why">
<node CREATED="1474283529703" ID="ID_156405236" MODIFIED="1474283534530" TEXT="code reuse between scripts"/>
</node>
</node>
<node CREATED="1474283555105" ID="ID_1810448028" MODIFIED="1474283560958" TEXT="including scripts from includes"/>
</node>
</node>
<node CREATED="1474282460624" ID="ID_85574928" MODIFIED="1474282463007" POSITION="left" TEXT="Script ideas">
<node CREATED="1474282464566" ID="ID_10906506" MODIFIED="1474282475079" TEXT="Install patchman"/>
<node CREATED="1474282475335" ID="ID_1029337117" MODIFIED="1474282479252" TEXT="Install datagrid"/>
<node CREATED="1474282479832" ID="ID_232837705" MODIFIED="1474282748832" TEXT="Configure MySQL">
<icon BUILTIN="full-4"/>
</node>
</node>
</node>
</map>
