package part2;

import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * Assembler that simulates how registers would be populated as instructions are read.
 * Also prints out the MIPS instructions as machine code to test with a CPU.
 */
public class Assembler {
    private HashMap<String,Integer> labels=new HashMap<>();
    private int index=0;
    private List<String> instructions=new ArrayList<>();
    //indices of registers
    private HashMap<String,Integer> registerIndexMap =new HashMap<>();
    private File file;

    /**
     * Takes in name of the file as a string to read. File must be in top
     * level of project.
     * @param fileName, String that is file name.
     */
    public Assembler(String fileName){
        file=new File(fileName);
        addRegisterIndices();
    }

    /**
     * Goes through file line by line and saves all the instructions and their
     * locations, also finds labels and saves their locations for branching
     * reasons. Ignores lines that begin with "." or "#".
     */
    public void readInstruction(){
        String line;
        Scanner scanner;
        try{
            scanner=new Scanner(file);
            while(scanner.hasNextLine()){
                line=scanner.nextLine();
                if(!line.contains("#") && !line.contains(".") && line.length()!=0){
                    instructions.add(line);
                    if(line.contains(":")){
                        String labelName=parseInstruction(line).get(0);
                        labels.put(labelName,index);
                    }
                    index++;
                }
            }
        }catch(IOException i){
            i.printStackTrace();
        }
    }

    /**
     * Parses the instruction line and returns the arguments in a List.
     * @param instruction, String that is the instruction line.
     * @return A List<String>
     */
    private List<String> parseInstruction(String instruction){
        String delims="[, ():   ]+";
        String[] arg=instruction.split(delims);
        return Arrays.asList(arg);
    }

    /**
     * Goes through indices of the instruction List and executes until the last
     * line is reached and always starts from the first line.
     */
    public void convertInstructions(){
        index=0;
        while(index<instructions.size()){
            String firstArg;
            int start;
            List<String> arguments=parseInstruction(instructions.get(index));
            firstArg=arguments.get(0);
            start=1;
            //checks to see if line had a label.
            if(labels.containsKey(firstArg)){
                firstArg=arguments.get(1);
                start=2;
            }
            switch(firstArg){
                case "add":
                    addFunction(arguments,start);
                    break;
                case "addi":
                    addiFunction(arguments,start);
                    break;
                case "sub":
                    subFunction(arguments,start);
                    break;
                case "nop":
                    nopFunction();
                    break;
                case "mult":
                    multFunction(arguments,start);
                    break;
                case "mfhi":
                    mfhiFunction(arguments.get(start));
                    break;
                case "mflo":
                    mfloFunction(arguments.get(start));
                    break;
                case "and":
                    andFunction(arguments,start);
                    break;
                case "or":
                    orFunction(arguments,start);
                    break;
                case "nor":
                    norFunction(arguments,start);
                    break;
                case "sll":
                    sllFunction(arguments,start);
                    break;
                case "srl":
                    srlFunction(arguments,start);
                    break;
                case "lw":
                    lwFunction(arguments,start);
                    break;
                case "sw":
                    swFunction(arguments,start);
                    break;
                case "slt":
                    sltFunction(arguments,start);
                    break;
                case "bne":
                    bneFunction(arguments,start);
                    break;
                case "beq":
                    beqFunction(arguments,start);
                    break;
                case "j":
                    jumpFunction(arguments.get(start));
                    break;
                default:
                    break;
            }
            index++;
        }
    }


    /**
     * Uses R instruction format. Converts all the arguments to the
     * corresponding binary numbers then passes them into rInstructions() to
     * handle the printing. Opcode is 0 and the function is 32.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void addFunction(List<String> var,int start){
        String rd=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        String opcode=Integer.toBinaryString(0);
        String funct=Integer.toBinaryString(32);
        String rs=Integer.toBinaryString(registerIndexMap.get(var.get(start+1)));
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start+2)));
        String shamt=Integer.toBinaryString(0);
        rInstructions(opcode,rs,rt,rd,shamt,funct);
    }

    /**
     * Uses the I instruction format, Converts all the arguments to the
     *  corresponding binary numbers then passes them into rInstructions() to
     *  handle the printing. The opcode is 8.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void addiFunction(List<String> var,int start){
        String opcode=Integer.toBinaryString(8);
        String val=Integer.toBinaryString(Integer.parseInt(var.get(start+2)));
        String rs=Integer.toBinaryString(registerIndexMap.get(var.get(start+1)));
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        iInstructions(opcode,rs,rt,val);
    }

    /**
     * Uses R instruction format. Converts all the arguments to the
     * corresponding binary numbers then passes them into rInstructions() to
     * handle the printing.Opcode is 0 and the function is 34.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void subFunction(List<String> var,int start){
        String rd=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        String opcode=Integer.toBinaryString(0);
        String funct=Integer.toBinaryString(34);
        String rs=Integer.toBinaryString(registerIndexMap.get(var.get(start+1)));
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start+2)));
        String shamt=Integer.toBinaryString(0);
        rInstructions(opcode,rs,rt,rd,shamt,funct);
    }

    /**
     * Uses R instruction format. Converts all the arguments to the
     * corresponding binary numbers then passes them into rInstructions() to
     * handle the printing.Opcode is 0 and the function is 24.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void multFunction(List<String> var,int start){
        String opcode=Integer.toBinaryString(0);
        String funct=Integer.toBinaryString(24);
        String rs=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start+1)));
        String shamt=Integer.toBinaryString(0);
        String rd=Integer.toBinaryString(0);
        rInstructions(opcode,rs,rt,rd,shamt,funct);
    }

    /**
     * Uses R instruction format. Converts all the arguments to the
     * corresponding binary numbers then passes them into rInstructions() to
     * handle the printing.Opcode is 0 and the function is 16.
     * @param regd Destination register name.
     */
    private void mfhiFunction(String regd){
        String opcode=Integer.toBinaryString(0);
        String funct=Integer.toBinaryString(16);
        String rd=Integer.toBinaryString(registerIndexMap.get(regd));
        String shamt=Integer.toBinaryString(0);
        rInstructions(opcode,opcode,opcode,rd,shamt,funct);
    }

    /**
     * Uses R instruction format. Converts all the arguments to the
     * corresponding binary numbers then passes them into rInstructions() to
     * handle the printing.Opcode is 0 and the function is 18.
     * @param regd Destination register name.
     */
    private void mfloFunction(String regd){
        String opcode=Integer.toBinaryString(0);
        String funct=Integer.toBinaryString(18);
        String rd=Integer.toBinaryString(registerIndexMap.get(regd));
        String shamt=Integer.toBinaryString(0);
        rInstructions(opcode,opcode,opcode,rd,shamt,funct);
    }

    /**
     * Uses R instruction format. Converts all the arguments to the
     * corresponding binary numbers then passes them into rInstructions() to
     * handle the printing. Opcode is 0 and the function is 36.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void andFunction(List<String> var,int start){
        String rd=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        String opcode=Integer.toBinaryString(0);
        String funct=Integer.toBinaryString(36);
        String rs=Integer.toBinaryString(registerIndexMap.get(var.get(start+1)));
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start+2)));
        String shamt=Integer.toBinaryString(0);
        rInstructions(opcode,rs,rt,rd,shamt,funct);
    }

    /**
     * Uses R instruction format. Converts all the arguments to the
     * corresponding binary numbers then passes them into rInstructions() to
     * handle the printing. Opcode is 0 and the function is 37.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void orFunction(List<String> var,int start){
        String rd=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        String opcode=Integer.toBinaryString(0);
        String funct=Integer.toBinaryString(37);
        String rs=Integer.toBinaryString(registerIndexMap.get(var.get(start+1)));
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start+2)));
        String shamt=Integer.toBinaryString(0);
        rInstructions(opcode,rs,rt,rd,shamt,funct);
    }


    /**
     * Uses R instruction format. Converts all the arguments to the
     * corresponding binary numbers then passes them into rInstructions() to
     * handle the printing. Opcode is 0 and the function is 39.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void norFunction(List<String> var,int start){
        String rd=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        String opcode=Integer.toBinaryString(0);
        String funct=Integer.toBinaryString(39);
        String rs=Integer.toBinaryString(registerIndexMap.get(var.get(start+1)));
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start+2)));
        String shamt=Integer.toBinaryString(0);
        rInstructions(opcode,rs,rt,rd,shamt,funct);
    }


    /**
     * Uses R instruction format. Converts all the arguments to the
     * corresponding binary numbers then passes them into rInstructions() to
     * handle the printing. Opcode is 0 and the function is 0.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void sllFunction(List<String> var,int start){
        String rd=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        String opcode=Integer.toBinaryString(0);
        String funct=Integer.toBinaryString(0);
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start+1)));
        String shamt=Integer.toBinaryString(Integer.parseInt(var.get(start+2)));
        rInstructions(opcode,opcode,rt,rd,shamt,funct);
    }


    /**
     * Uses R instruction format. Converts all the arguments to the
     * corresponding binary numbers then passes them into rInstructions() to
     * handle the printing. Opcode is 0 and the function is 2.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void srlFunction(List<String> var,int start){
        String rd=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        String opcode=Integer.toBinaryString(0);
        String funct=Integer.toBinaryString(2);
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start+1)));
        String shamt=Integer.toBinaryString(Integer.parseInt(var.get(start+2)));
        rInstructions(opcode,opcode,rt,rd,shamt,funct);
    }

    /**
     * Uses the I instruction format, Converts all the arguments to the
     *  corresponding binary numbers then passes them into rInstructions() to
     *  handle the printing. The opcode is 35.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void lwFunction(List<String> var,int start){
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        String opcode=Integer.toBinaryString(35);
        String rs=Integer.toBinaryString(registerIndexMap.get(var.get(start+2)));
        String immediate=Integer.toBinaryString(Integer.parseInt(var.get(start+1)));
        iInstructions(opcode,rs,rt,immediate);
    }

    /**
     * Uses the I instruction format, Converts all the arguments to the
     *  corresponding binary numbers then passes them into rInstructions() to
     *  handle the printing. The opcode is 43.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void swFunction(List<String> var,int start){
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        String opcode=Integer.toBinaryString(43);
        String rs=Integer.toBinaryString(registerIndexMap.get(var.get(start+2)));
        String immediate=Integer.toBinaryString(Integer.parseInt(var.get(start+1)));
        iInstructions(opcode,rs,rt,immediate);
    }

    /**
     * Uses R instruction format. Converts all the arguments to the
     * corresponding binary numbers then passes them into rInstructions() to
     * handle the printing. Opcode is 0 and the function is 42.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void sltFunction(List<String> var,int start){
        String rd=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        String opcode=Integer.toBinaryString(0);
        String funct=Integer.toBinaryString(42);
        String rs=Integer.toBinaryString(registerIndexMap.get(var.get(start+1)));
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start+2)));
        String shamt=Integer.toBinaryString(0);
        rInstructions(opcode,rs,rt,rd,shamt,funct);
    }


    /**
     * Uses the I instruction format, Converts all the arguments to the
     * corresponding binary numbers then passes them into rInstructions() to
     * handle the printing. The opcode is 5. Return is calculated by finding
     * location of label then calculating distance from the next line.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void bneFunction(List<String> var,int start){
        String rs=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start+1)));
        String opcode=Integer.toBinaryString(5);
        String label=var.get(start+2);
        int labelLoc=labels.get(label);
        int addressToJump;
        addressToJump=labelLoc-(index+1);
        String immediate=Integer.toBinaryString(addressToJump);
        iInstructions(opcode,rs,rt,immediate);
    }


    /**
     * Uses the I instruction format, Converts all the arguments to the
     *  corresponding binary numbers then passes them into rInstructions() to
     * handle the printing. The opcode is 4. Return is calculated by finding
     * location of label then calculating distance from the next line.
     * @param var Arguments from the instructions.
     * @param start Starting point of the arguments.
     */
    private void beqFunction(List<String> var,int start){
        String rs=Integer.toBinaryString(registerIndexMap.get(var.get(start)));
        String rt=Integer.toBinaryString(registerIndexMap.get(var.get(start+1)));
        String opcode=Integer.toBinaryString(4);
        String label=var.get(start+2);
        int labelLoc=labels.get(label);
        int addressToJump;
        addressToJump=labelLoc-(index+1);
        String immediate=Integer.toBinaryString(addressToJump);
        iInstructions(opcode,rs,rt,immediate);
    }

    /**
     * Uses the J instruction format, expects the name of the label to
     * correspond to the index it exits in. Multiplies the index by 4 to
     * replicate the byte sized distances of the addresses.
     * @param label A String.
     */
    private void jumpFunction(String label){
        String opcode=Integer.toBinaryString(2);
        String immediate=Integer.toBinaryString(labels.get(label)*4);
        jInstruction(opcode,immediate);
    }

    /**
     * Using the instruction for sll %zero,$zero,$zero as nop has no real
     * function besides wasting a cycle.
     */
    private void nopFunction(){
        System.out.println("00000000000000000000000000000000");
    }

    /**
     * Used to print the j instructions neatly by adding the corresponding
     * the zeros to complete the full 32 sized instructions.
     * @param opcode String that is the binary opcode.
     * @param immediate String that is the address.
     */
    private void jInstruction(String opcode,String immediate){
        int opcodeSize=6;
        int addressSize=26;
        String instruction="";
        for(int i=opcode.length();i<opcodeSize;i++){
            instruction+="0";
        }
        instruction+=opcode;
        for(int i=immediate.length();i<addressSize;i++){
            instruction+="0";
        }
        System.out.println(instruction+immediate);
    }

    /**
     * Used to print the r instructions making sure that its the full 32
     * sized binary number. Adds the corresponding zeroes to do this.
     * @param opcode String that is the binary opcode.
     * @param rs String that is the binary rs.
     * @param rt String that is the binary rt.
     * @param rd String that is the binary rd.
     * @param shamt String that is the binary shamt.
     * @param funct String that is the binary funct.
     */
    private void rInstructions(String opcode,String rs,String rt,String rd,
                               String shamt,String funct){
        int opcodeSize=6;
        int rsSize=5;
        int rtSize=5;
        int rdSize=5;
        int shamtSize=5;
        int functSize=6;
        String instruction="";
        for(int i=opcode.length();i<opcodeSize;i++){
            instruction+="0";
        }
        instruction+=opcode;
        for(int i=rs.length();i<rsSize;i++){
            instruction+="0";
        }
        instruction+=rs;
        for(int i=rt.length();i<rtSize;i++){
            instruction+="0";
        }
        instruction+=rt;
        for(int i=rd.length();i<rdSize;i++){
            instruction+="0";
        }
        instruction+=rd;
        for(int i=shamt.length();i<shamtSize;i++){
            instruction+="0";
        }
        instruction+=shamt;
        for(int i=funct.length();i<functSize;i++){
            instruction+="0";
        }
        instruction+=funct;
        System.out.println(instruction);
    }

    /**
     * Used to print the i instructions nicely by adding the zeroes so that
     * it shows the full 32 sized instruction.
     * @param opcode String that is the opcode.
     * @param rs String that is the rs.
     * @param rt String that is the rt.
     * @param immediate String that is the immediate.
     */
    private void iInstructions(String opcode,String rs,String rt,
                               String immediate){
        int opcodeSize=6;
        int rsSize=5;
        int rtSize=5;
        int immediateSize=16;
        String instruction="";
        for(int i=opcode.length();i<opcodeSize;i++){
            instruction+="0";
        }
        instruction+=opcode;
        for(int i=rs.length();i<rsSize;i++){
            instruction+="0";
        }
        instruction+=rs;
        for(int i=rt.length();i<rtSize;i++){
            instruction+="0";
        }
        instruction+=rt;
        if(immediate.length()<immediateSize) {
            for (int i = immediate.length(); i < immediateSize; i++) {
                instruction += "0";
            }
            instruction += immediate;
        }else{
            instruction+=immediate.substring(0,16);
        }
        System.out.println(instruction);
    }


    /**
     * Maps all the register names with the correct indices.
     */
    private void addRegisterIndices(){
        registerIndexMap.put("$zero",0);
        registerIndexMap.put("$at",1);
        registerIndexMap.put("$v0",2);
        registerIndexMap.put("$v1",3);
        registerIndexMap.put("$a0",4);
        registerIndexMap.put("$a1",5);
        registerIndexMap.put("$a2",6);
        registerIndexMap.put("$a3",7);
        registerIndexMap.put("$t0",8);
        registerIndexMap.put("$t1",9);
        registerIndexMap.put("$t2",10);
        registerIndexMap.put("$t3",11);
        registerIndexMap.put("$t4",12);
        registerIndexMap.put("$t5",13);
        registerIndexMap.put("$t6",14);
        registerIndexMap.put("$t7",15);
        registerIndexMap.put("$s0",16);
        registerIndexMap.put("$s1",17);
        registerIndexMap.put("$s2",18);
        registerIndexMap.put("$s3",19);
        registerIndexMap.put("$s4",20);
        registerIndexMap.put("$s5",21);
        registerIndexMap.put("$s6",22);
        registerIndexMap.put("$s7",23);
        registerIndexMap.put("$t8",24);
        registerIndexMap.put("$t9",25);
        registerIndexMap.put("$k0",26);
        registerIndexMap.put("$k1",27);
        registerIndexMap.put("$gp",28);
        registerIndexMap.put("$sp",29);
        registerIndexMap.put("$fp",30);
        registerIndexMap.put("$ra",31);
    }

    public static void main(String[] args){
        Assembler mips=new Assembler(args[0]);
        mips.readInstruction();
        mips.convertInstructions();
    }
}
