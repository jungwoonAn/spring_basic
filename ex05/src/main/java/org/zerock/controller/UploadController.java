package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	
	@GetMapping("/uploadForm")
	public void uploadForm() {
		
		log.info("upload form");
	}
	
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		
		String uploadFolder = "C:\\upload";
				
		for(MultipartFile multipartFile : uploadFile) {
			log.info("----------");
			log.info("Upload file Name : " + multipartFile.getOriginalFilename());
			log.info("Upload File Size : " + multipartFile.getSize());
			
			// 파일 저장
			// 파일 경로 객체 설정 C:\\upload\\봄spring.jsp
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile);  // 파일 저장
			}catch(Exception e) {
				log.error(e.getMessage());
			}
		}
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		
		log.info("upload ajax");
	}
	
	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.
			APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> 
		uploadAjaxPost(MultipartFile[] uploadFile) {		
		log.info("upload ajax post.....");
		
		List<AttachFileDTO> list = new ArrayList<>();		
		String uploadFolder = "C:\\upload";
		
		String uploadFolderPath = getFolder();  // 2025\01\01
		// 년/월/일 폴더 생성
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		log.info("uploadPath" + uploadPath);  // C:\\upload\2025\01\01
		
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}		
		
		for(MultipartFile multipartFile : uploadFile) {
			log.info("----------");
			log.info("Upload File Name : " + multipartFile.getOriginalFilename());
			log.info("Upload File Size : " + multipartFile.getSize());
			
			AttachFileDTO attachDTO = new AttachFileDTO();  // 첨부파일 객체 생성
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			// IE has file path
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			log.info("only file name : " + uploadFileName);
			
			attachDTO.setFileName(uploadFileName);  // 원본파일명 속성 추가
			attachDTO.setUploadPath(uploadFolderPath);  // 파일저장 경로 속성 추가
			
			// 파일명 중복 방지
			UUID uuid = UUID.randomUUID();
			log.info("----------");
			log.info("uuid : " + uuid.toString());
			
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			attachDTO.setUuid(uuid.toString());  // uuid 속성 추가
			
			// 파일 경로 객체 설정 C:\\upload\파일 -> C:\\upload\년\월\일\파일
//			File saveFile = new File(uploadFolder, uploadFileName);
			File saveFile = new File(uploadPath, uploadFileName);
			
			try {
				multipartFile.transferTo(saveFile);  // 파일 저장
				
				if(checkImageType(saveFile)) {					
					attachDTO.setImage(true);  // image 속성 추가
					
					// 썸네일 경로 설정
					FileOutputStream thumbnail = new FileOutputStream(new File(
							uploadPath, "s_" + uploadFileName));
										
					// 썸네일 생성
					Thumbnailator.createThumbnail(multipartFile.getInputStream(),
							thumbnail, 100, 100);
					
					thumbnail.close();					
				}
				
				// 리스트에 객체 추가
				list.add(attachDTO);
				
			}catch(Exception e) {
				log.error(e.getMessage());
			}
		}
		
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	// 오늘 날짜로 폴더 경로 생성
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();

		String str = sdf.format(date);
								// 윈도우 : \, 리눅스,맥 : /
		return str.replace("-", File.separator);
	}
	
	// 이미지 파일 여부 판단
	private boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			
			log.info("contentType : " + contentType);
			return contentType.startsWith("image");
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return false;
	}
	
	// 이미지 데이터 전송
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName) {
		log.info("fileName" + fileName);
		
		File file = new File("c:\\upload\\" + fileName);
		
		ResponseEntity<byte[]> result = null;
		
		try {
			HttpHeaders header = new HttpHeaders();
			
			// 브라우저에 보내주는 MIME 타입이 파일의 종류에 따라 달라져서
			// probeContentType()으로 적적한 MIME 타입을 헤더에 포함되게 처리
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<> (FileCopyUtils.copyToByteArray(file),
					header, HttpStatus.OK);
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;		
	}
	
	// 첨부파일 다운로드
	@GetMapping(value = "/download", produces = 
		{MediaType.APPLICATION_OCTET_STREAM_VALUE})
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") 
		String userAgent, String fileName) {
		log.info("download file : " + fileName);
		
		Resource resource = new FileSystemResource("c:\\upload\\" + fileName);
		log.info("resource : " + resource);
		
		if(resource.exists() == false) {  // 다운받을 파일이 존재하지 않으면
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		String resourceName = resource.getFilename();
		
		// remove UUID
		String resourceOrginalName = resourceName.substring(resourceName
				.indexOf("_") + 1);
		
		HttpHeaders headers = new HttpHeaders();
		try {			
//			headers.add("Content-Disposition", "attachment; filename=" + 
//					new String(resourceName.getBytes("UTF-8"), "ISO-8859-1"));
//			headers.add("Content-Disposition", "attachment; filename=" + 
//					URLEncoder.encode(resourceName, "utf-8"));
			headers.add("Content-Disposition", "attachment; filename=" + 
					URLEncoder.encode(resourceOrginalName, "utf-8"));
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	// 첨부파일 삭제
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		log.info("deleteFile : " + fileName);
		
		File file;
		
		try {
			file = new File("c:\\upload\\" + URLDecoder.decode(fileName, "utf-8"));
			
			file.delete();
			
			if(type.equals("image")) {
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				log.info("largeFileName" + largeFileName);
				
				file = new File(largeFileName);
				file.delete();
			}
		}catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
}