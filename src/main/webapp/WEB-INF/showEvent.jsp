<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title><c:out value="${event.name}"/></title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<body class="my-4 container">
	<h2><c:out value="${event.name}"/></h2>
	<div class="row my-4">
		<div class="col">
			<div class="">
				<p>Host: <c:out value="${event.host.firstName} ${event.host.lastName}"/></p>
				<p>Date: <fmt:formatDate value="${event.date}" pattern="MMMMM d, yyyy"/></p>
				<p>Location: <c:out value="${event.location}, ${event.state}"/></p>
				<p>People who are attending this event: <c:out value="${event.attendees.size()}"/></p>
			</div>
			<table class="table">
				<thead>
					<tr>
						<th>Name</th>
						<th>Location</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${event.attendees}" var="person">
						<tr>
							<td><c:out value="${person.firstName} ${person.lastName}"/></td>
							<td><c:out value="${person.location}"/></td>
						</tr>
					</c:forEach>		
				</tbody>
			</table>
		</div>
	
		<div class="col">
			<h3>Message Wall</h3>
			<div class="border" style="height: 250px; overflow-y:scroll;">
				<c:forEach items="${event.commenters}" var="message">
					<p class="p-3"><c:out value="${message.firstName} says: ${message.comment}"/></p>
					<hr class="ml-3 mr-5" style="border: 1px dashed #C0C0C0" color="#FFFFFF">
				</c:forEach>
			</div>
			<form:form action="${event.id}/addMessage" modelAttribute="message" class="my-5">
				<form:input type="hidden" path="firstName" value="${user.firstName}"/>
				<form:input type="hidden" path="lastName" value="${user.lastName}"/>
				<form:input type="hidden" path="event" value="${event.id}"/>
				<div class="form-group">
				    <form:label path="comment">Add a comment:</form:label>
				    <form:textarea path="comment" class="form-control" rows="3"></form:textarea>
				</div>
				<div class="text-right">
					<button type="submit" class="btn btn-primary">Submit</button>
				</div>
			</form:form>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>