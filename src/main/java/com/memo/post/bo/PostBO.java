package com.memo.post.bo;

import java.io.IOException;
import java.util.Collections;
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
	private static final int POST_MAX_SIZE = 3;
	
	@Autowired
	private PostDAO postDAO;
	
	@Autowired // spring bean으로 만들어졌기 때문에 autowired로 가져올 수 있다.
	private FileManagerService fileManagerService;
	
	// post를 여러개 가져오기 때문에
	public List<Post> getPostListByUserId(int userId, Integer prevId, Integer nextId) {
		// 게시글 번호 10 9 8 | 7 6 5 | 4 3 2 | 1 
		// 1) 다음: 가장 작은 수(오른쪽 값) => nextIdParam 쿼리: nextIdParam 보다 작은 3개(Limit)를 가져온다.
		// 2) 이전: 가장 큰 수(왼쪽 값) => prevIdParam 쿼리: prevIdParam 보다 큰 3개(Limit)를 가져온다. 순서가 뒤집히므로 코드에서 정렬을 뒤집는다.
		
		// BO에서 가공을 해준다.
		String direction = null;
		Integer standardId = null;
		
		if (prevId != null) {
			// 이전 버튼 클릭
			direction = "prev";
			standardId = prevId;
			
			// 정렬을 뒤집어야 한다.
			List<Post> postList = postDAO.selectPostListByUserId(userId, direction, standardId, POST_MAX_SIZE);
			Collections.reverse(postList);
			return postList;
		} else if (nextId != null) {
			// 다음 버튼 클릭
			direction = "next";
			standardId = nextId;
		}
		
		return postDAO.selectPostListByUserId(userId, direction, standardId, POST_MAX_SIZE);
	}
	
	// 가장 오른쪽 페이지인가?
	public boolean isLastPage(int userId, int nextId) {
		// 게시글 번호 10 9 8 | 7 6 5 | 4 3 2 | 1 
		// 1
		return nextId == postDAO.selectPostIdByUserIdAndSort(userId, "ASC"); // postId == nextId
	}

	// 가장 왼쪽 페이지인가?
	public boolean isFirstPage(int userId, int prevId) {
		// 10
		return prevId == postDAO.selectPostIdByUserIdAndSort(userId, "DESC");
	}
	 
	// post 1개만 가져오기 때문에
	public Post getPostByPostIdAndUserId(int postId, int userId) {
		return postDAO.selectPostByPostIdAndUserId(postId, userId);
	}
	
	public int createPost(int userId, String userLoginId, String subject, String content, MultipartFile file) {
		String imagePath = generateimagePathByFile(userLoginId, file);
		log.info("##### 이미지 주소: " + imagePath);
		
		return postDAO.insertPost(userId, subject, content, imagePath);
	}
	
	public int updatePost(int postId, int userId, String userLoginId, String subject, String content, MultipartFile file) {
		
		String imagePath = generateimagePathByFile(userLoginId, file);
		log.info("##### 수정된 이미지 주소: " + imagePath);
		
		if (imagePath != null) {
			Post post = postDAO.selectPostByPostIdAndUserId(postId, userId);
			String oldImagePath = post.getImagePath();
			try {
				fileManagerService.deleteFile(oldImagePath);
			} catch (IOException e) {
				log.error("[파일삭제] 삭제 중 에러: " + postId + " " + oldImagePath);
			}
		}
		return postDAO.updatePost(postId, userId, subject, content, imagePath);
	}

	public int deletePost(int postId, int userId) {
		
		Post post = postDAO.selectPostByPostIdAndUserId(postId, userId);
		String oldImagePath = post.getImagePath();
		
		if (oldImagePath != null) {
			try {
				fileManagerService.deleteFile(oldImagePath);
			} catch (IOException e) {
				log.error("[파일삭제] 삭제 중 에러: " + postId + " " + oldImagePath);
			}
		}
		
		return postDAO.deletePost(postId); 
	}
	
	private String generateimagePathByFile(String userLoginId, MultipartFile file) {
		// file을 가지고 image URL로 구성하고 DB에 넣는다.
		String imagePath = null;
		if (file != null) {
			try {
				// 컴퓨터(서버)에 파일 업로드 후 웹으로 접근할 수 있는 image URL을 얻어낸다.
				imagePath = fileManagerService.saveFile(userLoginId, file);
			} catch (IOException e) {
				log.error("[파일 업로드] " + e.getMessage());
			}
		}
		return imagePath;
	}
	
	
}
