package com.syzc.common.kit;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import org.apache.poi.POIXMLDocument;
import org.apache.poi.hslf.extractor.PowerPointExtractor;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.usermodel.Range;
import org.apache.poi.openxml4j.exceptions.OpenXML4JException;
import org.apache.poi.xslf.extractor.XSLFPowerPointExtractor;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.xmlbeans.XmlException;

public class FileContent {
	private static String content = "";	//文件内容
	
	public static String getFileContent(File file) {
		content = "";
		String type = file.getName().substring(file.getName().lastIndexOf(".") + 1);
		if ("txt".equalsIgnoreCase(type)) {
			content += txt2String(file);
		} else if ("doc".equalsIgnoreCase(type)) {
			content += doc2String(file);
		} else if ("docx".equalsIgnoreCase(type)) {
			content += docx2String(file);
		} else if ("xls".equalsIgnoreCase(type)) {
			content += xls2String(file);
		} else if ("xlsx".equalsIgnoreCase(type)) {
			content += xlsx2String(file);
		} else if ("ppt".equalsIgnoreCase(type)) {
			content += ppt2String(file);
		} else if ("pptx".equalsIgnoreCase(type)) {
			content += pptx2String(file);
		}
		System.out.println("name:"+file.getName());
		System.out.println("path:"+file.getPath());
		System.out.println(content);
		return content;
	}

	/**
	 * 读取(.xlsx)文件内容
	 * @param file
	 * @return 返回内容
	 */
	private static String xlsx2String(File file) {
		String result = "";
		try {
			FileInputStream fis = new FileInputStream(file);
			
			StringBuilder sb = new StringBuilder();
			
			XSSFWorkbook xwb = new XSSFWorkbook(fis);
			int sheetNum = xwb.getNumberOfSheets();
			
			for (int i = 0; i < sheetNum; i++) {
				XSSFSheet xs = xwb.getSheetAt(i);
				int rowsNum = xs.getPhysicalNumberOfRows();
				for (int j = 0; j < rowsNum; j++) {
					XSSFRow cells = xs.getRow(j);
					int cellsNum = cells.getPhysicalNumberOfCells();
					for (int k = 0; k < cellsNum; k++) {
						sb.append(cells.getCell(k));
					}
				}
			}
			
			fis.close();
			
			result += sb.toString();
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 读取(.xls)文件内容
	 * @param file
	 * @return 返回内容
	 */
	private static String xls2String(File file) {
		// TODO Auto-generated method stub
		String result = "";
		try {
			FileInputStream fis = new FileInputStream(file);
			
			StringBuilder sb = new StringBuilder();
			
			HSSFWorkbook hwb = new HSSFWorkbook(fis);
			int sheetNum = hwb.getNumberOfSheets();
			
			for (int i = 0; i < sheetNum; i++) {
				HSSFSheet hs = hwb.getSheetAt(i);
				int rowsNum = hs.getPhysicalNumberOfRows();
				for (int j = 0; j < rowsNum; j++) {
					HSSFRow cells = hs.getRow(j);
					int cellsNum = cells.getPhysicalNumberOfCells();
					for (int k = 0; k < cellsNum; k++) {
						sb.append(cells.getCell(k));
					}
				}
			}
			
			fis.close();
			
			result += sb.toString();
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 读取(.docx)类型文件的内容，通过poi.jar
	 * @param file的类型
	 * @return 返回文件的内容
	 */
	private static String docx2String(File file) {
		String result = "";
		try {
			FileInputStream fis = new FileInputStream(file);//文件输入流
			
            XWPFDocument document = new XWPFDocument(fis);
            XWPFWordExtractor extractor = new XWPFWordExtractor(document);
            result += extractor.getText();
		
			fis.close();
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 读取(.doc)类型文件的内容，通过poi.jar
	 * @param file的类型
	 * @return 返回文件的内容
	 */
	private static String doc2String(File file) {
		String result = "";
		try {
			FileInputStream fis = new FileInputStream(file);//文件输入流
			
			HWPFDocument document = new HWPFDocument(fis);
			Range range = document.getRange();
			result += range.text();
			
			fis.close();
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 读取(.txt)文件的内容
	 * 
	 * @param file想要读取的文件类型
	 * @return 返回文件内容
	 */
	private static String txt2String(File file) {
		String result = "";
		
		try {
			BufferedReader reader = new BufferedReader(new FileReader(file));
			String s = "";
			while ((s = reader.readLine()) != null) {
				result += s + "\n";
			}
			
			reader.close();
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	/**
	 * 读取(.ppt)文件的内容
	 * 
	 * @param file
	 * @return
	 */
	private static String ppt2String(File file) {
		FileInputStream is;
		PowerPointExtractor extractor = null;
		try {
			is = new FileInputStream(file);
			try {
				extractor = new PowerPointExtractor(is);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return extractor.getText();
	}
	/**
	 * 读取(.pptx)的文件内容
	 * 
	 * @param file
	 * @return
	 */
	private static String pptx2String(File file) {
		
		String result = "";
		String filePath = file.getAbsolutePath();
		try {
			result = new XSLFPowerPointExtractor(POIXMLDocument.openPackage(filePath)).getText();
		} catch (XmlException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (OpenXML4JException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
}
