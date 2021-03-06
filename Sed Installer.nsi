; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "GNUWin32"
!define PRODUCT_VERSION "4.1.5"
!define PRODUCT_PUBLISHER "GNUWin32"
!define PRODUCT_WEB_SITE "http://gnuwin32.sourceforge.net"
;!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\sed.exe"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "GNU General Public License.txt"
; Directory page
;!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------
Name "${PRODUCT_NAME}"
OutFile "GNUProducts.exe"
InstallDirRegKey HKLM "Software\Altigen Communications, Inc.\MaxDecoder" "InstallationLocation"
ShowInstDetails show

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "sed.exe"
  File "libiconv2.dll"
  File "libintl3.dll"
  File "join.exe"
  File "gdate.exe"
  File "gsort.exe"
  File "grep.exe"
  File "pcre3.dll"
  File "regex2.dll"
  File "awk.exe"
  File "gawk.exe"
  File "pgawk.exe"
  File "printf.exe"
  
  
SectionEnd


Section -Post
;  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\sed.exe"
SectionEnd