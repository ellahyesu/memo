<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<h1 class="p-4 text-center">로그인</h1>
    
<div class="d-flex justify-content-center align-items-center mb-4">
	<div class="login-box col-4">
		<form id="loginForm" method="post" action="/user/sign_in">
			<input type="text" id="loginId" name="loginId" class="form-control mt-2" placeholder="아이디">
			<input type="password" id="password" name="password" class="form-control mt-2" placeholder="비밀번호">
			
			<button type="submit" class="btn btn-primary w-100 mt-3">로그인</button>
			<a href="/user/sign_up_view" class="btn btn-secondary btn-block mt-2">회원가입</a>
		</form>
	</div>
</div>

<script>
	$(document).ready(function() {
		$('#loginForm').submit(function(e) {
			e.preventDefault(); // submit 수행 중단
			
			// validation
			let loginId = $('input[name=loginId]').val().trim();
			if (loginId == '') {
				alert("아이디를 입력해주세요.");
				return;
			}
			
			let password = $('#password').val();
			if (password == '') {
				alert("비밀번호를 입력해주세요.");
				return;
			}
			
			// AJAX로 submit
			let url = $(this).attr('action');
			let params = $(this).serialize(); // form태그 안의 name들을 다 가져와서 키밸류쌍으로 담겨짐
			
			$.post(url, params).done(function(data) {
				if (data.result == 'success') {
					location.href="/post/post_list_view";
				} else {
					alert("로그인에 실패했습니다. 다시 시도해주세요.");
				}
			});
			
		});
	});
</script>