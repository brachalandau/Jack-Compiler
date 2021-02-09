note
	description: "Summary description for {INSTRUCTIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

 
class
	INSTRUCTIONS

create
	make

feature -- Initialization
--localse

	true_labelnumbering: INTEGER_32
	false_labelnumbering: INTEGER_32
	counter_label: INTEGER_32


	make (stam: INTEGER_32)
		do
			true_labelnumbering := -1
			false_labelnumbering := -1
			counter_label:=-1
		end

	false_promotelabelnumbering
		do
			false_labelnumbering := false_labelnumbering + 1
		end

	true_promotelabelnumbering
		do
			true_labelnumbering := true_labelnumbering + 1
		end

	add: STRING_8
		do
            Result:="%N@SP"+"%NM=M-1"+"%NA=M"+"%ND=M"+"%N@SP"+"%NM=M-1"+"%NA=M"+"%NM=D+M"+"%N@SP"+"%NM=M+1"

		end

	sub: STRING_8
		do

            Result:="%N@SP%N"+"M=M-1%N"+"A=M%N"+"D=M%N"+"@SP%N"+"M=M-1%N"+"A=M%N"+"M=M-D%N"+"@SP%N"+"M=M+1%N"
		--	Result := "%N" + "@SP" + "%N" + "A=M-1" + "%N" + "D=M" + "%N" + "A=A-1" + "%N" + "M=M-D" + "%N" + "@SP" + "%N" + "M=M-1" + "%N"
		end

	neg: STRING_8
			--Arithmetic instructions Comparison
		do
			Result := "%N" + "@SP%N" + "A=M-1%N" + "M=-M"
		end

	eq: STRING_8
		do
			false_promotelabelnumbering
			true_promotelabelnumbering
			Result := "%N@SP" + "%NM=M-1" + "%NA=M" + "%ND=M" + "%N@SP" + "%NM=M-1" + "%NA=M" + "%ND=M-D" + "%N@IF_TRUE" + true_labelnumbering.out + "%ND;JEQ" + "%N@SP" + "%NA=M" + "%NM=0" + "%N@IF_FALSE" + false_labelnumbering.out + "%N0;JMP" + "%N(IF_TRUE" + true_labelnumbering.out + ")" + "%N@SP" + "%NA=M" + "%NM=-1" + "%N(IF_FALSE" + false_labelnumbering.out + ")" + "%N@SP" + "%NM=M+1"
		end

	gt: STRING_8
			-- x>y
		do
			false_promotelabelnumbering
			true_promotelabelnumbering
			Result := "%N@SP" + "%NM=M-1" + "%NA=M" + "%ND=M" + "%N@SP" + "%NM=M-1" + "%NA=M" + "%ND=M-D" + "%N@IF_TRUE" + true_labelnumbering.out + "%ND;JGT" + "%N@SP" + "%NA=M" + "%NM=0" + "%N@IF_FALSE" + false_labelnumbering.out + "%N0;JMP" + "%N(IF_TRUE" + true_labelnumbering.out + ")" + "%N@SP" + "%NA=M" + "%NM=-1" + "%N(IF_FALSE" + false_labelnumbering.out + ")" + "%N@SP" + "%NM=M+1"
		end

	lt: STRING_8
			-- x<y
		do
			false_promotelabelnumbering
			true_promotelabelnumbering
			Result := "%N@SP" + "%NM=M-1" + "%NA=M" + "%ND=M" + "%N@SP" + "%NM=M-1" + "%NA=M" + "%ND=M-D" + "%N@IF_TRUE" + true_labelnumbering.out + "%ND;JLT" + "%N@SP" + "%NA=M" + "%NM=0" + "%N@IF_FALSE" + false_labelnumbering.out + "%N0;JMP" + "%N(IF_TRUE" + true_labelnumbering.out + ")" + "%N@SP" + "%NA=M" + "%NM=-1" + "%N(IF_FALSE" + false_labelnumbering.out + ")" + "%N@SP" + "%NM=M+1"
		end

	andours: STRING_8
			--Logical instructions
		do
			Result := "%N" + "@SP%N" + "A=M-1%N" + "D=M%N" + "A=A-1%N" + "M=D&M" + "%N" + "@SP%N" + "M=M-1"
		end

	orours: STRING_8
		do
			Result := "%N" + "@SP%N" + "A=M-1%N" + "D=M%N" + "A=A-1%N" + "M=D|M" + "%N" + "@SP%N" + "M=M-1"
		end

	notours: STRING_8
		do
			Result := "%N" + "@SP%N" + "A=M-1%N" + "M=!M"
		end

	pushconstent (x: STRING_8): STRING_8
			--pop not needed
		do
            Result:="%N@"+x+"%ND=A"+"%N@SP"+"%NA=M"+"%NM=D"+"%N@SP"+"%NM=M+1"
		--	Result := "%N@" + x + "%ND=A%N" + "@SP%N" + "A=M%N" + "M=D%N" + "@SP%N" + "M=M+1"
		end

	pushlocal (x: STRING_8): STRING_8
		do
			Result := "%N@" + x + "%N" + "D=A%N" + "@LCL%N" + "A=M+D%N" + "D=M%N" + "@SP%N" + "A=M%N" + "M=D%N" + "@SP%N" + "M=M+1"
		end

	poplocal (x: STRING_8): STRING_8
		local
			str: STRING_8
			i: INTEGER_32
		do
			str := "%N" + "@SP%N" + "A=M-1%N" + "D=M%N" + "@LCL%N" + "A=M%N"
			from
				i := 0
			until
				i = x.to_integer
			loop
				str.append ("A=A+1%N")
				i := i + 1
			end
			Result := str + "M=D%N" + "@SP%N" + "M=M-1"
		end

	pushargument (x: STRING_8): STRING_8
		do
            Result:="%N@"+x+"%ND=A"+"%N@ARG"+"%NA=M+D"+"%ND=M"+"%N@SP"+"%NA=M"+"%NM=D"+"%N@SP"+"%NM=M+1"
       	--	Result := "%N@" + x + "%ND=A" + "%N@ARG" + "%NA=M" + "%ND=D+A" + "%NA=D" + "%ND=M" + "%N@SP" + "%NA=M" + "%NM=D" + "%N@SP" + "%NM=M+1"
		end

	popargument (x: STRING_8): STRING_8
		local
			str: STRING_8
			i: INTEGER_32
		do
			str := "%N" + "@SP%N" + "A=M-1%N" + "D=M%N" + "@ARG%N" + "A=M%N"
			from
				i := 0
			until
				i = x.to_integer
			loop
				str.append ("A=A+1%N")
				i := i + 1
			end
			Result := str + "M=D%N" + "@SP%N" + "M=M-1"
		end

	pushthis (x: STRING_8): STRING_8
		do
			Result := "%N@" + x + "%N" + "D=A%N" + "@THIS%N" + "A=M+D%N" + "D=M%N" + "@SP%N" + "A=M%N" + "M=D%N" + "@SP%N" + "M=M+1"
		end

	popthis (x: STRING_8): STRING_8
			--temps indexes are between 5-12
		local
			str: STRING_8
			i: INTEGER_32
		do
			str := "%N" + "@SP%N" + "A=M-1%N" + "D=M%N" + "@THIS%N" + "A=M%N"
			from
				i := 0
			until
				i = x.to_integer
			loop
				str.append ("A=A+1%N")
				i := i + 1
			end
			Result := str + "M=D%N" + "@SP%N" + "M=M-1"
		end

	pushthat (x: STRING_8): STRING_8
			--temps indexes are between 5-12
		do
			Result := "%N@" + x + "%N" + "D=A%N" + "@THAT%N" + "A=M+D%N" + "D=M%N" + "@SP%N" + "A=M%N" + "M=D%N" + "@SP%N" + "M=M+1"
		end

	popthat (x: STRING_8): STRING_8
			--@THIS
			--temp=1 --@THAT
		local
			str: STRING_8
			i: INTEGER_32
		do
			str := "%N" + "@SP%N" + "A=M-1%N" + "D=M%N" + "@THAT%N" + "A=M%N"
			from
				i := 0
			until
				i = x.to_integer
			loop
				str.append ("A=A+1%N")
				i := i + 1
			end
			Result := str + "M=D%N" + "@SP%N" + "M=M-1"
		end

	pushtemp (x: STRING_8): STRING_8
			--@THIS
		local
			temp: INTEGER_32
		do
			temp := 5 + x.to_integer
			if (temp < 13) then
				Result := "%N@" + temp.out + "%ND=M" + "%N@SP" + "%NA=M" + "%NM=D" + "%N@SP" + "%NM=M+1"
			else
				Result := "error index is larger then 12"
			end
		end

	poptemp (x: STRING_8): STRING_8
			--temp=1  --@THAT
		local
			temp: INTEGER_32
		do
			temp := 5 + x.to_integer
			if (temp < 13) then
				Result := "%N" + "@SP%N" + "A=M-1%N" + "D=M%N" + "@" + temp.out + "%NM=D%N" + "@SP%N" + "M=M-1"
			else
				Result := "error index is larger then 12"
			end
		end

	pushpointer (x: STRING_8): STRING_8
		local
			temp: INTEGER_32
		do
			temp := x.to_integer
			if temp = 0 then
				Result := "%N" + "@THIS%N" + "D=M%N" + "@SP%N" + "A=M%N" + "M=D%N" + "@SP%N" + "M=M+1"
			else
				Result := "%N" + "@THAT%N" + "D=M%N" + "@SP%N" + "A=M%N" + "M=D%N" + "@SP%N" + "M=M+1"
			end
		end

	poppointer (x: STRING_8): STRING_8
		local
			temp: INTEGER_32
		do
			temp := x.to_integer
			if temp = 0 then
				Result := "%N" + "@SP%N" + "A=M-1%N" + "D=M%N" + "@THIS%N" + "M=D%N" + "@SP%N" + "M=M-1"
			else
				Result := "%N" + "@SP%N" + "A=M-1%N" + "D=M%N" + "@THAT%N" + "M=D%N" + "@SP%N" + "M=M-1"
			end
		end

	pushstatic (x: STRING_8;curentclass: STRING_8 ): STRING_8
		do
			Result := "%N@" + curentclass + "." + x + "%ND=M%N" + "@SP%N" + "A=M%N" + "M=D%N" + "@SP%N" + "M=M+1%N"
		end

	popstatic (x: STRING_8;curentclass: STRING_8 ): STRING_8
		do
			Result := "%N" + "@SP%N" + "A=M-1%N" + "D=M%N" + "@" + curentclass + "." + x + "%N" + "M=D%N" + "@SP%N" + "M=M-1"
		end

    --targil-2
    label(labelName:STRING ;fileName:STRING):STRING
	do
		result:= "%N(" +fileName+"_"+ labelName + ")"
	end

	goto(labelName:STRING; fileName:STRING):STRING
	do
		result:= "%N@" + fileName+"_"+ labelName +"%N0;JMP"
	end

	if_goto(labelName:STRING; fileName:STRING):STRING
	do
		result:= "%N@SP%N"+ "M=M-1%N"+"A=M%N"+"D=M%N"+ "@" +fileName+"_"+labelName +"%ND;JNE"
	end

	call(funcName:STRING argNum:STRING):STRING
	local
		address,newArgNum1:STRING
		newArgNum:INTEGER_32
	do
	counter_label:=counter_label+1
	newArgNum:=argNum.to_integer
	newArgNum:=newArgNum+5
	newArgNum1:=newArgNum.out
	address:="ReturnAddress_"+counter_label.out --to string
	result:="%N@"+funcName+"_"+address+"%ND=A%N"+"@SP%N"+"A=M%N"+"M=D%N"+"@SP%N"+"M=M+1" --push return address
			+"%N@LCL"+"%ND=M%N"+"@SP%N"+"A=M%N"+"M=D%N"+"@SP%N"+"M=M+1"--push lcl
			+"%N@ARG"+"%ND=M%N"+"@SP%N"+"A=M%N"+"M=D%N"+"@SP%N"+"M=M+1"--push arg
			+"%N@THIS"+"%ND=M%N"+"@SP%N"+"A=M%N"+"M=D%N"+"@SP%N"+"M=M+1"--push this
			+"%N@THAT"+"%ND=M%N"+"@SP%N"+"A=M%N"+"M=D%N"+"@SP%N"+"M=M+1"--push that
			+"%N@SP"+"%ND=M%N"+"@"+newArgNum1+ "%ND=D-A%N"+"%N"+ "@ARG%N"+"M=D"    --arg=SP-argnum-d
			+"%N@SP %ND=M %N@LCL %NM=D"--locl=sp
			+"%N@"+ funcName +"%N0;JMP%N"
			+"("+funcName+"_"+address+")"
	end

    function(funcName:STRING localsAmount:STRING):STRING
	do
		result:= "%N(" +funcName + ")"+"%N@"+localsAmount+"%ND=A%N"+"@"+funcName+"_"+"End%N"+"D;JEQ%N"--CHECK IF THERE IS 0 LOCALS
		+"("+funcName+"_Loop"+")"+ "%N@SP%N"+"A=M%N"+"M=0%N"--M=0 ENTERING 0 TO THE FIRST EMTY SPACE IN THE STACK
		+"@SP%N"+"M=M+1%N"--pointes to the next empty place in stack
		+"@"+funcName+"_"+"Loop%N"+"D=D-1;JNE%N"+"("+funcName+"_End)"--jups to the start of curentclass.loop while D!=0 AND DOES D--
	end

	return:STRING
	do
		result:= "%N@LCL%N"+"D=M%N"--D=to where the local variables are stored // FRAME = LCL
				+"@5%N"+"A=D-A%N"+"D=M%N"+"@13%N"+"M=D%N"--rigester 13=value of return address //RET = * (FRAME-5), RAM[13] = (LOCAL - 5)
				+"@SP%N"+"M=M-1%N"+"A=M%N"+"D=M%N"+"@ARG%N"+"A=M%N"+"M=D%N"--wiil save the head of the stack-the return value-to where the arg pointer points to// * ARG = pop()
				+"@ARG%N"+"D=M%N"+"@SP%N"+"M=D+1%N"--we r moving the sp pointer to point to where we just pushed in the return value+1// SP = ARG+1
				--restoring the segements:
				+"@LCL%N"+"M=M-1%N"+"A=M%N"+"D=M%N"+"@THAT%N"+"M=D%N"--// THAT = *(FRAM-1)
				+"@LCL%N"+"M=M-1%N"+"A=M%N"+"D=M%N"+"@THIS%N"+"M=D%N"--// THIS = *(FRAM-2)
				+"@LCL%N"+"M=M-1%N"+"A=M%N"+"D=M%N"+"@ARG%N"+"M=D%N"--// ARG = *(FRAM-3)
				+"@LCL%N"+"M=M-1%N"+"A=M%N"+"D=M%N"+"@LCL%N"+"M=D%N"--// LCL = *(FRAM-4)
				--back to return address-in code
				+"@13%N"+"A=M%N"+"0;JMP"--// goto RET (from register 13, that we saved in line 2)
	end

end -- class INSTRUCTIONS

