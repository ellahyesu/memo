package com.memo.common;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component // 일반적인 스프링빈
public class FileManagerService {

	private Logger logger = LoggerFactory.getLogger(FileManagerService.class);
	
	// 실제 이미지가 (컴퓨터에) 저장될 경로
	public final static String FILE_UPLOAD_PATH = "C:\\Users\\ella\\6_spring_project\\memo\\memo_workspace\\Memo\\images/";
	
	// 이미지를 저장 -> URL Path 리턴
	public String saveFile(String userLoginId, MultipartFile file) throws IOException {
		
		// 파일을 컴퓨터에 저장
		
		// 1. 파일 디렉토리 경로 만듦(겹치지 않게)  예: coco12_1645784562/sun.png
		String directoryName = userLoginId + "_" + System.currentTimeMillis() + "/"; // coco12_1645784562/
		String filePath = FILE_UPLOAD_PATH + directoryName;
		
		File directory = new File(filePath);
		if (directory.mkdir() == false) { // 파일을 업로드 할 filePath 경로에 폴더 생성을 한다.
			logger.error("[파일업로드] 디렉토리 생성 실패 " + userLoginId + ", " + filePath);
			// 디렉토리 생성 실패
			return null;
		}
		
		// 파일 업로드 => byte 단위로 업로드 한다.
		byte[] bytes = file.getBytes();
		Path path = Paths.get(filePath + file.getOriginalFilename()); // OriginalFilename => input에서 사용자가 업로드한 파일명
		Files.write(path, bytes);
		
		// 이미지 URL 만들어 리턴
		// http://localhost/images/coco12_1629441276231/PaintJS[EXPORT] (5).png
		return "/images/" + directoryName + file.getOriginalFilename();
	}
	
}
