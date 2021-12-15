package ca.jrvs.apps.practice;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegexExcImp implements RegexExc {
    boolean success = false;

    public static void main(String[] args) {
        RegexExcImp obj = new RegexExcImp();
        obj.matchJpeg("image.jpeg");
        System.out.println(obj.success);
        obj.matchIp("0.234.456.8");
        System.out.println(obj.success);
        obj.isEmptyLine("");
        System.out.println(obj.success);
    }

    public boolean matchJpeg(String filename) {
        String pattern = "([^\\s]+(\\.(?i)(jpg|jpeg))$)";
        Pattern pattern1 = Pattern.compile(pattern);
        Matcher matcher = pattern1.matcher(filename);
        if (matcher.matches())
            success = true;
        return success;
    }

    public boolean matchIp(String ip) {
        String pattern = "(([0-9]|[1-9][0-9]|[1-9][0-9][0-9])\\.([0-9]|[1-9][0-9]|[1-9][0-9][0-9])\\.([0-9]|[1-9][0-9]|[1-9][0-9][0-9])\\.([0-9]|[1-9][0-9]|[1-9][0-9][0-9]))";
        Pattern pattern1 = Pattern.compile(pattern);
        Matcher matcher = pattern1.matcher(ip);
        if (matcher.matches())
            success = true;
        return success;
    }

    public boolean isEmptyLine(String line) {
        String pattern = "(^\\s*$)";
        Pattern pattern1 = Pattern.compile(pattern);
        Matcher matcher = pattern1.matcher(line);
        if (matcher.matches())
            success = true;
        return success;
    }
}