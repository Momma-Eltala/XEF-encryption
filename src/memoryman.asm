section .bss
e_d resb 1
Block resb 128
filename resb 8
fileoutputname resb 8
passwordlocation resb 8
section .text

shiftingmain:

     shiftrightsetup: ;sets up shifting bits to the right for us
        mov ch, 127
        mov rbx, Block 
	
        shift_right_loop1:
            cmp ch, 0
            je shiftrightdone
            mov cl, 5
            mov ax, word [rbx]

            shift_right_loop2:
                shr ax, 1
                jc addcarryhigh
                
                shift_right_loop3:
                cmp cl, 0
                dec cl
                jne shift_right_loop2
                dec ch
                mov word [rbx], ax
                inc rbx
                jmp shift_right_loop1



                addcarryhigh:
                    mov dx, 0x7fff
                    not dx
                    add ax, dx
                    clc
                    jmp shift_right_loop3

        shiftrightdone:

		ret

    shiftleftsetup: ;sets up shifting bits to the left for us
        mov ch, 127
        mov rbx, Block
        add rbx, 127

        shift_left_loop1:
            cmp ch, 0
            je shiftleftdone
            mov cl, 5
            mov ax, word [rbx]


            shift_left_loop2:
                shl ax, 1
                jc addcarrylow
                shift_left_loop3:
                cmp cl, 0
                dec cl
                jne shift_left_loop2
                dec ch
                mov word [rbx], ax
                dec rbx
                jmp shift_left_loop1



                addcarrylow:
                    mov dx, 0x01
                    add ax, dx
                    clc
                    jmp shift_left_loop3

shiftleftdone:
	ret

