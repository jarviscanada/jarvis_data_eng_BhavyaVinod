package ca.jrvs.apps.grep;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.ListIterator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JavaGrepImp implements JavaGrep {

    final Logger logger = LoggerFactory.getLogger(JavaGrep.class);

    @Override
    public String getRegex() {
        return regex;
    }

    public void setRegex(String regex) {
        this.regex = regex;
    }

    @Override
    public String grtOutFile() {
        return null;
    }

    @Override
    public void process() throws IOException {
        List<String> matchedLines = new ArrayList<>();
        List<File> files = listFiles(getRootPath());

        for(File file: files){
            List<String> lines = readlines(file);

            for(String line: lines){
                if(containsPattern(line)){
                    matchedLines.add(line);
                }
            }
        }
        writeToFile(matchedLines);
    }

    @Override
    public List<File> listFiles(String rootDir) {
        File dir = new File(rootDir);
        File[] allFiles = dir.listFiles();

        if(allFiles == null) {
            allFiles = new File[]{};
        }

        List<File> fileList = new ArrayList<>(Arrays.asList(allFiles));
        ListIterator<File> fileListIterator = fileList.listIterator();
        List<File> subFile = new ArrayList<>();

        while(fileListIterator.hasNext()){
            File currentFile = fileListIterator.next();

            if(currentFile.isDirectory()){
                fileListIterator.remove();
                subFile.addAll(this.listFiles(currentFile.getAbsolutePath()));
            }

        }
        fileList.addAll(subFile);
        return fileList;
    }

    @Override
    public List<String> readlines(File inputFile) throws IllegalArgumentException {
        List<String> fileLines = new ArrayList<>();
        try {
            BufferedReader reader = new BufferedReader(new FileReader(inputFile));
            String line = reader.readLine();
            while(line != null){
                fileLines.add(line);
                line=reader.readLine();
            }
            reader.close();
        } catch (Exception e) {
            logger.error("please provide valid input file", e);
        }
        return fileLines;
    }

    @Override
    public boolean containsPattern(String line) {
        return line.matches(getRegex());
    }

    @Override
    public void writeToFile(List<String> lines) throws IOException {
        BufferedWriter writer = new BufferedWriter(new FileWriter(getOutFile()));

        for(String matchedLine: lines){
            writer.write(matchedLine + System.lineSeparator());
        }
        writer.close();
    }

    @Override
    public String getRootPath() {
        return rootPath;
    }

    public void setRootPath(String rootPath) {
        this.rootPath = rootPath;
    }

    public String getOutFile() {
        return outFile;
    }

    public void setOutFile(String outFile) {
        this.outFile = outFile;
    }


    private String regex;
    private String rootPath;
    private String outFile;

    public static void main(String[] args) {
        if (args.length != 3) {
            throw new IllegalArgumentException("USAGE: JavaGrep regex rootPath outFile");
        }

        JavaGrepImp javaGrepImp = new JavaGrepImp();
        javaGrepImp.setRegex(args[0]);
        javaGrepImp.setRootPath(args[1]);
        javaGrepImp.setOutFile(args[2]);

        try {
            javaGrepImp.process();
        } catch (Exception ex){
            javaGrepImp.logger.error("Please provide valid arguments", ex);
        }
    }
}