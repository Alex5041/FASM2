format PE console
entry start
include 'win32a.inc'
 
section '.data' data readable writeable
ns dd ?
hout dd ?
c dq ?
e dq ?
x dq ?
sum dq 1.00
iter dq 0.00
zer dq 0.00
one dq 1.00
percentage dq 0.001
strs  db 'e^x = %lf', 10, 0
strIn dq '%lf', 10, 0
frstStr db 'Type in a real number x ', 10, 0
 
section '.code' code readable executable
start:

        invoke printf, frstStr
        invoke scanf, strIn,x
        finit
        fld [sum]                                        ; ���������� �������� �����, ������� (����������) �
        fld [one]                                        ; ������ �������� � ����
        fld [iter]
        jmp sumCalc
        cont:

getOut:                                                  ; ���������� ���������
        fstp st0                                         ; ������� ����� �� ������ ����������
        fstp st0                                         ; ������� ����� �� �������� ���� �����
        fst [c]
        invoke printf, strs, dword[c], dword[c+4]        ; ����� ����������
        invoke getch
        invoke ExitProcess,0


sumCalc:                                                 ; ���� �������� �����
        fadd [one]                                       ; iter++
        fxch st1                                         ; st0 = a_{i-1}
        fmul [x]                                         ; a_i = a_{i-1} * x / iter
        fdiv st0, st1


        fxch st2                                         ; st0 = sum
        fadd st0, st2                                    ; sum += a_i
        fld st0                                          ; st0 = sum (��� ��������� ������ ����� ����������)
        fmul [percentage]                                ; st0 *= 0.001

        fld st3                                          ; st0 = a_i (��� ��������� ������ ����� ����������)
        fabs                                             ; st0 = |st0|
        fxch st1                                         ; swap |a_i|, sum*0.001

        fcomi st1                                        ; �������� |a_i|, sum*0.001
        ja getOut                                        ; ���� sum*0.001 ������, ����� �� ���������

        fstp st0                                         ; ������� ����� �� ������ ����������
        fstp st0                                         ; ������� ����� �� �������� ���� �����
        fxch st2                                         ; ���������� ����� � ��������� �������� �����, �� ����
        fxch st1                                         ; �������������� ������������������ �������� � �����
        jmp sumCalc                                      ; ������ �����

jmp cont
 
section '.idata' import data readable writeable
 
library kernel32,'kernel32.dll',\
user32, 'user32.dll',\
msvcrt, 'msvcrt.dll'
 
include '\api\kernel32.inc'
include '\api\user32.inc'

 import msvcrt,\
           printf, 'printf',\
           sprintf, 'sprintf',\
           scanf, 'scanf',\
           getch, '_getch'

; ��������� �������� ��� ������������� ��������� �����

;format PE console
;entry start
;include 'win32a.inc'
 
;section '.data' data readable writeable
;ns dd ?
;hout dd ?
;c dq ?
;e dq ?
;x dq ?
;zer dq 0.00
;strs  db '%lf', 10, 0
;strIn dq '%lf', 10, 0
;ifBig db 'st0 is bigger', 10, 0
;ifSmall db 'st0 is smaller', 10, 0
;fsc db '2 power int', 10, 0
 
;section '.code' code readable executable
;start:
                            ; ���� � ���, ����� ����� ��������� log_2(e) � ��������������� �������� f2xm1
                            ; e^x = e^(log_2(e)* x)
                            ; �������� � ���, ��� f2xm1 �������� ��� ����� �� ���������� (-1,1)
                            ; �����  log_2(e)* x ������� �� ����� � ������� �����, �������� ���������
                            ; 2^[log_2(e)* x] � 2^(log_2(e)* x - [log_2(e)* x])
                            ; � �������
;        invoke scanf, strIn,x
;        finit
;        fld [x]
;        fldl2e
;        fmul st0, st1       ; st0 = (log_2(e)* x)
;        fst [c]
;        fst st1             ; st2 = log_2(e)* x
;        frndint             ; st0 = [log_2(e)* x]
;
;        fst [e]
;        fcomi st1
;        ja decrem
;cont:
;        fxch st1
;        fsub st0, st1
;        fst st2            ; st2 = log_2(e) * x - [log_2(e) * x]
;        fstp st0 ; pop st0
;        fld1
;        fscale     ; st0 = 2^st1 == 2^[log_2(e) * x]
;        fld st2
;        f2xm1
;        fld1
;        faddp st1 ,st
;        fmul st0, st1
;        fst [c]
;        invoke printf, strs, dword[c], dword[c+4]
;invoke getch
;invoke ExitProcess,0
;decrem:
;fld1
;fsubp st1, st0
;jmp cont

;section '.idata' import data readable writeable
 
;library kernel32,'kernel32.dll',\
;user32, 'user32.dll',\
;msvcrt, 'msvcrt.dll'
 
;include '\api\kernel32.inc'
;include '\api\user32.inc'

;import msvcrt,\
;           printf, 'printf',\
;           sprintf, 'sprintf',\
;           scanf, 'scanf',\
;           getch, '_getch'