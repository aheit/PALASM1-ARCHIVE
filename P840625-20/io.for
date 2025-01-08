C*******************************
C
C PATCHES FOR GFORTRAN COMPILER
C (C) 2024 ANDREAS HEITMANN
C
C*******************************
C
      LOGICAL FUNCTION IOREAD(UNIT, MODE, DEV, FILENAME)
      INTEGER*1 UNIT, MODE, DEV
C      CHARACTER*1 FILENAME(20)

      INTEGER STATUS
      CHARACTER*20 FILENAME

      LOGICAL FILE_EXISTS, UNIT_OPEN

C Set initial return value to .FALSE. (indicating success)
      IOREAD = .FALSE.

C Check if the UNIT is within the valid range 5 - 20
      IF (UNIT .LT. 5 .OR. UNIT .GT. 20) THEN
          IOREAD = .TRUE.
          RETURN
      END IF

C     Build FILENAME from the FILE array (convert to a single CHARACTER
C     string) 
c$$$      FILENAME = ''
c$$$      DO 10 I = 1, 20
c$$$         FILENAME = FILENAME // FILE(I:I)
c$$$   10 CONTINUE

C     Check if the file already exists and if the unit is already open
      INQUIRE (UNIT=UNIT, OPENED=UNIT_OPEN)
      INQUIRE (FILE=FILENAME, EXIST=FILE_EXISTS)
      
C     Return .TRUE. if file does not exist or if the unit is already
C     open
      IF (.NOT. FILE_EXISTS .OR. UNIT_OPEN) THEN
         IOREAD = .TRUE.
         RETURN
      END IF

C     Open the file based on MODE
      IF (MODE .EQ. 0) THEN
C     Binary Stream Mode - Open as unformatted, sequential access
         OPEN(UNIT=UNIT, FILE=FILENAME, STATUS='OLD', ACCESS
     $        ='SEQUENTIAL', FORM='UNFORMATTED') 
      ELSE IF (MODE .EQ. 1) THEN
C     Binary Blocked Mode - Simulate by using unformatted, direct access
C     with fixed record length 
         OPEN(UNIT=UNIT, FILE=FILENAME, STATUS='OLD', ACCESS='DIRECT',
     $        FORM='UNFORMATTED', RECL=512) 
      ELSE IF (MODE .EQ. 2) THEN
C     ASCII Stream Mode - Open as formatted, sequential access
         OPEN(UNIT=UNIT, FILE=FILENAME, STATUS='OLD', ACCESS
     $        ='SEQUENTIAL', FORM='FORMATTED') 
      ELSE
C     Invalid MODE specified
          IOREAD = .TRUE.
          RETURN
      END IF

C     Check if device DEV is 0 (logged-in device) or matches conditions
      IF (DEV .NE. 0 .AND. DEV .NE. 1) THEN
C     For example purposes, assume DEV 0 is current device, 1 is allowed
          CLOSE(UNIT)
          IOREAD = .TRUE.
          RETURN
      END IF

      RETURN
      END

      LOGICAL FUNCTION IOCLOS(UNIT)
      INTEGER*1 UNIT
      LOGICAL UNIT_OPEN

C     Set initial return value to .FALSE. (indicating success)
      IOCLOS = .FALSE.

C     Check if the UNIT is within the valid range 5 - 20
      IF (UNIT .LT. 5 .OR. UNIT .GT. 20) THEN
          IOCLOS = .TRUE.
          RETURN
      END IF

C     Check if the unit is already open
      INQUIRE (UNIT=UNIT, OPENED=UNIT_OPEN)

C     If the unit is not open, return .TRUE.
      IF (.NOT. UNIT_OPEN) THEN
          IOCLOS = .TRUE.
          RETURN
      END IF

C     Attempt to close the file associated with UNIT
      CLOSE(UNIT)

C     For sequential files, simulate zeroing the remainder of the disk block
C     and updating the directory (not directly supported in Fortran 77)
C     Here we assume these tasks are successfully completed as placeholders

      RETURN
      END

      LOGICAL FUNCTION IOWRIT(UNIT, MODE, DEV, FILENAME)
      INTEGER*1 UNIT, MODE, DEV
C      CHARACTER*1 FILE(20)
      
      INTEGER STATUS
      CHARACTER*20 FILENAME

      LOGICAL UNIT_OPEN, FILE_EXISTS

C     Set initial return value to .FALSE. (indicating success)
      IOWRIT = .FALSE.

C     Check if the UNIT is within the valid range 5 - 20
      IF (UNIT .LT. 5 .OR. UNIT .GT. 20) THEN
          IOWRIT = .TRUE.
          RETURN
      END IF

C     Build FILENAME from the FILE array (convert to a single CHARACTER
C     string)
C      FILENAME = ''
C      DO 10 I = 1, 20
C         FILENAME = FILENAME // FILE(I:I)
C   10 CONTINUE

C     Check if the unit is already open
      INQUIRE (UNIT=UNIT, OPENED=UNIT_OPEN)
      IF (UNIT_OPEN) THEN
          IOWRIT = .TRUE.
          RETURN
      END IF

C     Check if the file already exists
      INQUIRE (FILE=FILENAME, EXIST=FILE_EXISTS)

C     If the file exists, delete it
      IF (FILE_EXISTS) THEN
          OPEN(UNIT=UNIT, FILE=FILENAME)
          CLOSE(UNIT, STATUS='DELETE')
      END IF

C     Attempt to create the file with specified mode
      IF (MODE .EQ. 0) THEN
C     Binary Stream Mode - Open as unformatted, sequential access
         OPEN(UNIT=UNIT, FILE=FILENAME, STATUS='NEW', ACCESS
     $        ='SEQUENTIAL', FORM='UNFORMATTED') 
      ELSE IF (MODE .EQ. 1) THEN
C     Binary Blocked Mode - Open as unformatted, direct access with
C     fixed record length 
         OPEN(UNIT=UNIT, FILE=FILENAME, STATUS='NEW', ACCESS='DIRECT',
     $        FORM='UNFORMATTED', RECL=512) 
      ELSE IF (MODE .EQ. 2) THEN
C     ASCII Stream Mode - Open as formatted, sequential access
         OPEN(UNIT=UNIT, FILE=FILENAME, STATUS='NEW', ACCESS
     $        ='SEQUENTIAL', FORM='FORMATTED') 
      ELSE
C     Invalid MODE specified
          IOWRIT = .TRUE.
          RETURN
      END IF

      RETURN
      END
