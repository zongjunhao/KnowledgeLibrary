package com.syzc.common.kit;

import java.io.File;
import java.net.ConnectException;

import com.artofsolving.jodconverter.DocumentConverter;
import com.artofsolving.jodconverter.openoffice.connection.OpenOfficeConnection;
import com.artofsolving.jodconverter.openoffice.connection.SocketOpenOfficeConnection;
import com.artofsolving.jodconverter.openoffice.converter.OpenOfficeDocumentConverter;

public class OfficeDoc2PDF {
	/*
	 * 通过oppenOffice进行转换 inputFile需要转的文件路径 pdfFile 生成后的pdf文件路径
	 */
	public void officeOpenPDF(String inputFile, String pdfFile) {
		OpenOfficeConnection connection = new SocketOpenOfficeConnection(8100);
		File inputFiles = new File(inputFile);

		File outputFile = new File(pdfFile);

		try {
			connection.connect();
			DocumentConverter converter = new OpenOfficeDocumentConverter(connection);
			converter.convert(inputFiles, outputFile);
			connection.disconnect();

		} catch (ConnectException e) {
			// TODO Auto-generated catch block
			System.out.println("openoffice报错");
			e.printStackTrace();
		}

	}
}
