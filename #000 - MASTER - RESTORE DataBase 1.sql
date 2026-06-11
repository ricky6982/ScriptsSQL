
use master

------- ------- -------- 
PRINT 'BACKUP'

use master

BACKUP DATABASE EVTC_BO_PAYE_PR 
TO DISK = 'C:\Desarrollo\DBs\Backups\20260609_1240_bo.bak'
WITH COMPRESSION, FORMAT;

BACKUP DATABASE EVTC_AAS_PAYE_PR
    TO DISK = 'C:\Desarrollo\DBs\Backups\20260528_1040_aas.bak'
WITH COMPRESSION, FORMAT;

------- ------- -------- 
PRINT 'RESTORE'

use master

ALTER DATABASE EVTC_BO_PAYE_PR SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
RESTORE DATABASE EVTC_BO_PAYE_PR
FROM DISK = 'C:\Desarrollo\DBs\Backups\payepr_qa_20260415\payepr_qa_bo_260415.bak'
WITH REPLACE;

------------------------------------------------------
USE master;

-- =====================
-- RESTORE BO
-- =====================
ALTER DATABASE EVTC_BO_PAYE_PR SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
RESTORE DATABASE EVTC_BO_PAYE_PR
FROM DISK = 'C:\Desarrollo\DBs\Backups\02\payepr_dev_bo_260610.bak'
WITH REPLACE,
     MOVE 'payepr_qa_bo'     TO 'C:\Desarrollo\DBs\EVTC_BO_PAYE_PR.mdf',
     MOVE 'payepr_qa_bo_log' TO 'C:\Desarrollo\DBs\EVTC_BO_PAYE_PR_log.ldf';
GO

-- =====================
-- RESTORE AAS
-- =====================
ALTER DATABASE EVTC_AAS_PAYE_PR SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
RESTORE DATABASE EVTC_AAS_PAYE_PR
FROM DISK = 'C:\Desarrollo\DBs\Backups\02\payepr_dev_aas_260610.bak'
WITH REPLACE,
     MOVE 'payepr_qa_aas'     TO 'C:\Desarrollo\DBs\EVTC_AAS_PAYE_PR.mdf',
     MOVE 'payepr_qa_aas_log' TO 'C:\Desarrollo\DBs\EVTC_AAS_PAYE_PR_log.ldf';
GO