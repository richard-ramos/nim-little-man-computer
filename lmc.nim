from strutils import parseInt, intToStr
from algorithm import fill
import terminal
import os

type
    MailBoxArray = array[100, int]

proc printState(programCnt: int, accumulator: int, mailbox: MailBoxArray)

var 
    mailbox: MailBoxArray
    lineCnt = 0

mailbox.fill(0)

# TODO: Fail if file doesnt exist

let input = open(paramStr(1))
    
for line in input.lines:
    try:
        mailbox[lineCnt] = parseInt(line)
    except ValueError:
        echo "Error> ", getCurrentExceptionMsg()
        quit()
    inc lineCnt
    if lineCnt > 99:
        break

input.close()  

var
    execute = true
    programCnt = 0
    accumulator = 0


while execute:
    let instruction = mailbox[programCnt];
    let code = int(instruction / 100);
    let index = int(instruction mod 100);
    
    printState(programCnt, accumulator, mailbox)

    case code
    of 1: # ADD 
        accumulator += mailbox[index]
    of 2: # SUBSTRACT
        accumulator -= mailbox[index]
    of 3: # STORE
        mailbox[index] = accumulator
    of 5: # LOAD
        accumulator = mailbox[index]
    of 6: # BRANCH
        programCnt = index
        continue
    of 7:
        if accumulator == 0:
            programCnt = index
            continue
    of 8:
        if accumulator >= 0:
            programCnt = index
            continue
    of 9: 
        if index == 1: # INPUT
            write(stdout, "Input> ")
            accumulator = parseInt(readLine(stdin))
        elif index == 2: # OUTPUT
            echo "Output> ", accumulator
            discard readLine(stdin)
        else:
            echo "Unknown instruction: ", mailbox[programCnt];
            discard readLine(stdin)
            execute = false
    of 0: # HALT
        execute = false
        continue
    else: 
        echo "Unknown instruction: ", mailbox[programCnt];
        discard readLine(stdin)
        execute = false
        continue

    inc programCnt

printState(programCnt, accumulator, mailbox)





proc cleanScreen*() =
    hideCursor()
    eraseScreen()
    setCursorpos(0, 0)
    showCursor()





proc printState(programCnt: int, accumulator: int, mailbox: MailBoxArray) = 
    cleanScreen()
    echo "Program Counter: ", programCnt + 1
    echo "Accumulator:     ", accumulator
    echo "Executing:       ", intToStr(mailbox[programCnt], 3)

    echo ""
    for i in countup(0, 9):
        for j in countup(0, 9):
            if programCnt == i*10+j:
                write(stdout, ">")
            else:
                write(stdout, " ")
            write(stdout, intToStr(i * 10 + j, 2))
            write(stdout, ": ")
            write(stdout,  intToStr(mailbox[i * 10 + j], 3))
            write(stdout, "   ")
        
        echo ""

    echo "-- press ANY key --"
    discard readLine(stdin)

