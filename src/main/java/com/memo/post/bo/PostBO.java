package com.memo.post.bo;

import java.io.IOException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.memo.common.FileManagerService;
import com.memo.post.dao.PostDAO;
import com.memo.post.model.Post;

@Service
public class PostBO {

	private Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private PostDAO postDAO;
	
	@Autowired // spring bean으로 만들어졌기 때문에 autowired로 가져올 수 있다.
	private FileManagerService fileManagerService;
	
	public List<Post> getPostListByUserId(int userId) {
		return postDAO.selectPostListByUserId(userId);
	}
	
	public int createPost(int userId, String userLoginId, String subject, String content, MultipartFile file) {
		// file을 가지고 image URL로 구성하고 DB에 넣는다.
		String imageUrl = null;
		if (file != null) {
			try {
				// 컴퓨터(서버)에 파일 업로드 후 웹으로 접근할 수 있는 image URL을 얻어낸다.
				imageUrl = fileManagerService.saveFile(userLoginId, file);
			} catch (IOException e) {
				log.error("[파일 업로드] " + e.getStackTrace());
			}
		}
		log.info("##### 이미지 주소: " + imageUrl);
		
		return postDAO.insertPost(userId, subject, content, imageUrl);
	}
}
