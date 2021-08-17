package com.memo.test;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.memo.test.bo.TestBO;

@Controller
public class TestController {
	
	@Autowired
	private TestBO testBO;
	
	@RequestMapping("/test")
	@ResponseBody
	public String test() {
		return "test hello world!!";
	}
	
	@RequestMapping("/test_db")
	@ResponseBody
	public Map<String, Object> testDb() {
		Map<String, Object> result = testBO.getUser(); 
		return result; // jackson 라이브러리 때문에 json으로 내려간다.
	}
	
	@RequestMapping("/test_jsp")
	public String testJsp() {
		return "test/test"; // /WEB-INF/jsp/           test/test             .jsp
	}
}
