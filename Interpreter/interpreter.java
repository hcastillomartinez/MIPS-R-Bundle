package part1;

import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * MIPS R instruction type interpreter. Simply pass in the instruction set
 * as a text file.
 */
public class Interpreter {
    private int high=0;
    private int low=0;
    //actual content of registers.
    private List<Integer> registers=new ArrayList<>(32);
    private List<Integer> mainMemory=new ArrayList<>(512);
    private HashMap<String,Integer> labels=new HashMap<>();
    private int index=0;
    private List<String> instructions=new ArrayList<>();
    //indices of registers
    private HashMap<String,Integer> registerMap=new HashMap<>();
    private File file;

    /**
     * Expects a file name, and file should be in the most upper level of the
     * project for program to find it.
     * @param file, String that is the file name.
     */
    public Interpreter(String file){
        this.file= new File(file);
        addRegisterToMap();
        initializeMainAndRegisters();
    }



    /**
     * Goes through file line by line and saves all the instructions and their
     * locations, also finds labels and saves their locations for branching
     * reasons. Ignores lines that begin with "." or "#".
     */
    public void readInstruction(){
        String line;
        try{
            Scanner scanner=new Scanner(file);
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
    public void executeInstructions(){
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
                    index=addFunction(arguments,start);
                    break;
                case "addi":
                    index=addImmediateFunction(arguments,start);
                    break;
                case "sub":
                    index=subFunction(arguments,start);
                    break;
                case "nop":
                    index=nopFunction();
                    break;
                case "mult":
                    index=multFunction(arguments,start);
                    break;
                case "mfhi":
                    index=mfhi(arguments.get(start));
                    break;
                case "mflo":
                    index=mflo(arguments.get(start));
                    break;
                case "and":
                    index=andFunction(arguments,start);
                    break;
                case "or":
                    index=orFunction(arguments,start);
                    break;
                case "nor":
                    index=norFunction(arguments,start);
                    break;
                case "sll":
                    index=sllFunction(arguments,start);
                    break;
                case "srl":
                    index=srlFunction(arguments,start);
                    break;
                case "lw":
                    index=lw(arguments,start);
                    break;
                case "sw":
                    index=sw(arguments,start);
                    break;
                case "slt":
                    index=sltFunction(arguments,start);
                    break;
                case "bne":
                    index=bneFunction(arguments,start);
                    break;
                case "beq":
                    index=beqFunction(arguments,start);
                    break;
                case "j":
                    index=jumpFunction(arguments.get(start));
                    break;
                default:
                    break;
            }
        }
    }

    /**
     * Sets all the registers and main memory indices to contain zero to
     * avoid nullpointerexceptions.
     */
    private void initializeMainAndRegisters(){
        for(int i=0;i<32;i++){
            registers.add(0);
        }
        for(int i=0;i<512;i++){
            mainMemory.add(0);
        }
    }

    /**
     * Nop function does nothing but emulate shifting a zero by zero.
     * @return Index to continue on.
     */
    private int nopFunction(){
        int zero=0<<0;
        return index+=1;
    }

    /**
     * Adds two numbers from registers and puts them into a destination
     * register.
     * @param variable, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int addFunction(List<String> variable,int start){
        int rd=registerMap.get(variable.get(start));
        int rs=registerMap.get(variable.get(start+1));
        int rt=registerMap.get(variable.get(start+2));
        registers.set(rd,(registers.get(rs)+registers.get(rt)));
        return index+=1;
    }

    /**
     * Puts word into registers that is from main memory.
     * @param variables, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int lw(List<String> variables,int start){
        int baseRegister=registerMap.get(variables.get(start+2));
        int baseRegisterContents=registers.get(baseRegister);
        int rd=registerMap.get(variables.get(start));
        int offset= Integer.parseInt(variables.get(start+1));
        registers.set(rd,mainMemory.get(baseRegisterContents+(offset%4)));
        return index+=1;
    }

    /**
     * Saves the word into the main memory starting from contents of a register.
     * @param variables, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int sw(List<String> variables,int start){
        int baseRegister=registerMap.get(variables.get(start+2));
        int baseRegisterContents=registers.get(baseRegister);
        int offset= Integer.parseInt(variables.get(start+1));
        int rd=registerMap.get(variables.get(start));
        int rdContents=registers.get(rd);
        mainMemory.set(baseRegisterContents+(offset%4),rdContents);
        return index+=1;
    }

    /**
     * Multiplies two numbers from registers and if it is <=32 bit number it
     * is placed into low, other wise it is split into high and low registers.
     * @param variable, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int multFunction(List<String> variable,int start){
        Long product;
        int rs=registers.get(registerMap.get(variable.get(start)));
        int rt=registers.get(registerMap.get(variable.get(start+1)));
        product=(long)rs*(long)rt;
        if(product<=Integer.MAX_VALUE){
            low=Math.toIntExact(product);
        }else{
            low=Integer.MAX_VALUE;
            high=Math.toIntExact(product-Integer.MAX_VALUE);
        }
        return index+=1;
    }

    /**
     * Moves content from hi register into destination specified.
     * @param rd, Destination register for the word.
     * @return Index to continue on.
     */
    private int mfhi(String rd){
        registers.set(registerMap.get(rd),high);
        return index+=1;
    }

    /**
     * Moves content of low register into the specified destination.
     * @param rd, Destination register for the word.
     * @return Index to continue on.
     */
    private int mflo(String rd){
        registers.set(registerMap.get(rd),low);
        return index+=1;
    }

    /**
     * Adds register content with a number specified and puts into the
     * destination register.
     * @param variable, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int addImmediateFunction(List<String> variable,int start){
        int rt=registerMap.get(variable.get(start));
        int rs=registerMap.get(variable.get(start+1));
        int value=Integer.parseInt(variable.get(start+2));
        registers.set(rt,(registers.get(rs)+value));
        return index+=1;
    }

    /**
     * Subtracts two register contents and places the value into a
     * destination register.
     * @param variable, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int subFunction(List<String> variable,int start){
        int rd=registerMap.get(variable.get(start));
        int rs=registerMap.get(variable.get(start+1));
        int rt=registerMap.get(variable.get(start+2));
        registers.set(rd,(registers.get(rs)-registers.get(rt)));
        return index+=1;
    }

    /**
     * Performs and bitwise operation on two register contents and places
     * them into destination register.
     * @param variable, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int andFunction(List<String> variable,int start){
        int rd=registerMap.get(variable.get(start));
        int rs=registerMap.get(variable.get(start+1));
        int rt=registerMap.get(variable.get(start+2));
        registers.set(rd,(registers.get(rs)&registers.get(rt)));
        return index+=1;
    }

    /**
     * Performs or bitwise operation on two register contents and places
     * them into destination register.
     * @param variable, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int orFunction(List<String> variable,int start){
        int rd=registerMap.get(variable.get(start));
        int rs=registerMap.get(variable.get(start+1));
        int rt=registerMap.get(variable.get(start+2));
        registers.set(rd,(registers.get(rs)|registers.get(rt)));
        return index+=1;
    }

    /**
     * Performs nor bitwise operation on two register contents and places
     * them into destination register.
     * @param variables, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int norFunction(List<String> variables,int start){
        int rd=registerMap.get(variables.get(start));
        int rs=registerMap.get(variables.get(start+1));
        int rt=registerMap.get(variables.get(start+2));
        registers.set(rd,~(registers.get(rs)|registers.get(rt)));
        return index+=1;
    }

    /**
     * Performs left shift on a register's contents and places
     * them into destination register, can be shifted by any amount.
     * @param variables, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int sllFunction(List<String> variables,int start){
        int rd=registerMap.get(variables.get(start));
        int rt=registerMap.get(variables.get(start+1));
        int shamt=Integer.parseInt(variables.get(start+2));
        registers.set(rd,(registers.get(rt)<<shamt));
        return index+=1;
    }

    /**
     * Performs right shift on a register's contents and places
     * them into destination register, can be shifted by any amount.
     * @param variables, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int srlFunction(List<String> variables, int start){
        int rd=registerMap.get(variables.get(start));
        int rt=registerMap.get(variables.get(start+1));
        int shamt=Integer.parseInt(variables.get(start+2));
        registers.set(rd,(registers.get(rt)>>shamt));
        return index+=1;
    }

    /**
     * Checks if one register is less than another, if true then first
     * destination register set to 1, otherwise set to 0.
     * @param variables, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int sltFunction(List<String> variables,int start){
        int rd=registerMap.get(variables.get(start));
        int rs=registerMap.get(variables.get(start+1));
        int rt=registerMap.get(variables.get(start+2));
        if(registers.get(rs)<registers.get(rt)){
            registers.set(rd,1);
        }else registers.set(rd,0);
        return index+=1;
    }

    /**
     * Checks if two registers are not equal, if true then method returns the
     * label location, otherwise just returns the next line number.
     * @param variables, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int bneFunction(List<String> variables, int start){
        int rs=registerMap.get(variables.get(start));
        int rt=registerMap.get(variables.get(start+1));
        int labelLocation=labels.get(variables.get(start+2));
        if(registers.get(rs)!=registers.get(rt)){
            return labelLocation;
        }
        return index+=1;
    }
    /**
     * Checks if two registers are equal, if true then method returns the
     * label location, otherwise just returns the next line number.
     * @param variables, List of arguments that are parsed already.
     * @param start, In denoting index to start reading from.
     * @return Index to continue on.
     */
    private int beqFunction(List<String> variables, int start){
        int rs=registerMap.get(variables.get(start));
        int rt=registerMap.get(variables.get(start+1));
        int labelLocation=labels.get(variables.get(start+2));
        if(registers.get(rs).equals(registers.get(rt))){
            return labelLocation;
        }
        return index+=1;
    }


    /**
     * Gets the location of the label and returns it.
     * @param label, Name of the label
     * @return Int that is location of label.
     */
    private int jumpFunction(String label){
        return labels.get(label);
    }

    /**
     * Maps all the register names with the correct indices.
     */
    private void addRegisterToMap(){
        registerMap.put("$zero",0);
        registerMap.put("$at",1);
        registerMap.put("$v0",2);
        registerMap.put("$v1",3);
        registerMap.put("$a0",4);
        registerMap.put("$a1",5);
        registerMap.put("$a2",6);
        registerMap.put("$a3",7);
        registerMap.put("$t0",8);
        registerMap.put("$t1",9);
        registerMap.put("$t2",10);
        registerMap.put("$t3",11);
        registerMap.put("$t4",12);
        registerMap.put("$t5",13);
        registerMap.put("$t6",14);
        registerMap.put("$t7",15);
        registerMap.put("$s0",16);
        registerMap.put("$s1",17);
        registerMap.put("$s2",18);
        registerMap.put("$s3",19);
        registerMap.put("$s4",20);
        registerMap.put("$s5",21);
        registerMap.put("$s6",22);
        registerMap.put("$s7",23);
        registerMap.put("$t8",24);
        registerMap.put("$t9",25);
        registerMap.put("$k0",26);
        registerMap.put("$k1",27);
        registerMap.put("$gp",28);
        registerMap.put("$sp",29);
        registerMap.put("$fp",30);
        registerMap.put("$ra",31);
    }


    public static void main(String[] args){
        Interpreter interpreter=new Interpreter(args[0]);
        interpreter.readInstruction();
        interpreter.executeInstructions();
        System.out.println("low: = "+Integer.toBinaryString(interpreter.low));
        System.out.println("hi: = "+Integer.toBinaryString(interpreter.high));
        interpreter.registers.forEach((n)-> System.out.print(Integer.toBinaryString(n)+" "));
        System.out.println();
        interpreter.mainMemory.forEach((n)-> System.out.print(Integer.toBinaryString(n)+" "));
    }

}
