<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div class="d-flex justify-content-center my-4">
	<div class="post-box">
		<h1>글 상세/수정</h1>
		
		<input type="text" name="subject" class="form-control mb-1" value="${post.subject}">
		<textarea name="content" class="form-control mb-3" rows="15" cols="100">${post.content}</textarea>
		
		<%-- 이미지가 있을 때에만 이미지 영역 추가 --%>
		<c:if test="${not empty post.imagePath}">
		<div>
			<img src="${post.imagePath}" alt="업로드 된 이미지" width="200px" height="130px">
		</div>
		</c:if>
		<div class="mt-1">
			<%-- 여러 파일을 업로드 할 경우에는 input태그 안에 multiple 프로퍼티를 추가한다. --%>
			<input type="file" name="image" accept=".jpg,.jpeg,.png,.gif">
		</div>
		
		<div class="clearfix mt-4">
			<button type="button" id="postDelBtn" class="float-left btn btn-secondary" data-post-id="${post.id}">삭제</button>
			<div class="float-right">
				<a href="/post/post_list_view" class="btn btn-dark">목록</a>
				<button type="button" id="saveBtn" class="btn btn-primary" data-post-id="${post.id}">수정</button>
			</div>
		</div>
	</div>
	
</div>

<script>
	$(document).ready(function() {
		// 삭제 버튼 클릭
		$('#postDelBtn').on('click', function() {
			
			alert($(this).data('post-id'));
			
			$.ajax({
				url: '/post/delete'
				, type: 'post'
				, data: {
					"postId": $(this).data('post-id')
				}, success: function(data) {
					if (data.result == 'success') {
						alert("메모가 삭제되었습니다.");
						location.href="/post/post_list_view";
					}
				}, error: function(e) {
					alert("메모 삭제에 실패했습니다." + e);
				}
			});
			
			
		});
		
		// 수정 버튼 클릭(수정한 글 내용 저장)
		$('#saveBtn').on('click', function() {
			// validation
			let subject = $('input[name=subject]').val().trim();
			if (subject == '') {
				alert("제목을 입력해주세요.");
				return;
			}
			
			let content = $('textarea[name=content]').val();
			if (content == '') {
				alert("내용을 입력해주세요.");
				return;
			}
			
			let file = $('input[name=image]').val();
			if (file != '') {
				let ext = file.split('.').pop().toLowerCase();
				if ($.inArray(ext, ['jpg', 'jpeg', 'gif', 'png']) == -1) {
					alert("jpg, jpeg, gif, png 파일만 업로드 할 수 있습니다.");
					$('input[name=image]').val('');
					return;
				}
			}
			
			// 서버에 보내기
			
			// form 태그객체를 자바스크립트에서 만든다.
			let formData = new FormData();
			formData.append("postId", $(this).data('post-id'));
			formData.append("subject", subject);
			formData.append("content", content);
			
			// $('input[name=image]')[0]  => 첫번째 input file 태그를 의미
			// .files[0]                  => 업로드 된 파일 중 첫번째를 의미
			formData.append("file", $('input[name=image]')[0].files[0]); 
			
			$.ajax({
				url: '/post/update'
				, type: 'post'
				, data: formData
				, processData: false
				, contentType: false
				, encType: 'multipart/form-data'

				, success: function(data) {
					if (data.result == 'success') {
						alert("메모가 수정되었습니다.");
						location.reload(); // 새로고침
					}
				}, error: function(e) {
					alert("메모 수정에 실패했습니다." + e);
				}
			});
			
		});
		
	});
</script>