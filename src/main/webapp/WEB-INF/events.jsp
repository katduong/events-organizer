<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Events</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
	
</head>
<body class="container my-4">
	<div class="row justify-content-between container">
		<h2 class="">Welcome, <c:out value="${user.firstName}"/></h2>
		<a href="/logout">Logout</a>
	</div>
	
	<div class="mt-2 mb-5">
		<h5 class="my-3">Here are some of the events in your state:</h5>
		<table class="table col-9">
			<thead>
				<tr>
					<th>Name</th>
					<th>Date</th>
					<th>Location</th>
					<th>Host</th>
					<th>Action/Status</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${eventsInState}" var="event">
					<tr>
						<td>
							<a href="<c:url value='events/${event.id}'/>">
								<c:out value="${event.name}"/>
							</a>
						</td>
						<td><fmt:formatDate value="${event.date}" pattern="MMMMM dd, yyyy"/></td>
						<td><c:out value="${event.location}"/></td>
						<td><c:out value="${event.host.firstName}"/></td>
						<td class="row">
							<c:choose>
								<c:when test="${event.host.id == user.id}">
									<a href="<c:url value='events/${event.id}/edit'/>">Edit</a>
									<a class="mx-3" href="<c:url value='events/${event.id}/delete'/>">Delete</a>
								</c:when>
								<c:when test="${user.eventsAttending.contains(event)}">
									<p class="mr-3">Joining</p>
									<a href="<c:url value='events/${event.id}/cancel'/>">Cancel</a>
								</c:when>
								<c:when test="${!user.eventsAttending.contains(event)}">
									<a href="<c:url value='/events/${event.id}/join'/>">Join</a>
								</c:when>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	
	<div class="my-5">
		<h5 class="my-3">Here are some of the events in other states:</h5>
		<table class="table col-9">
			<thead>
				<tr>
					<th>Name</th>
					<th>Date</th>
					<th>Location</th>
					<th>State</th>
					<th>Host</th>
					<th>Action</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${eventsInOtherStates}" var="event">
					<tr>
						<td>
							<a href="<c:url value='events/${event.id}'/>">
								<c:out value="${event.name}"/>
							</a>
						</td>
						<td><fmt:formatDate value="${event.date}" pattern="MMMMM dd, yyyy"/></td>
						<td><c:out value="${event.location}"/></td>
						<td><c:out value="${event.state}"/></td>					
						<td><c:out value="${event.host.firstName}"/></td>
						<td class="row">
							<c:choose>
								<c:when test="${event.host.id == user.id}">
									<a href="<c:url value='events/${event.id}/edit'/>">Edit</a>
									<a class="mx-3" href="<c:url value='events/${event.id}/delete'/>">Delete</a>
								</c:when>
								<c:when test="${!user.eventsAttending.contains(event)}">
									<a href="<c:url value='/events/${event.id}/join'/>">Join</a>
								</c:when>
								<c:otherwise>
									<p class="mr-3">Joining</p>
									<a href="<c:url value='events/${event.id}/cancel'/>">Cancel</a>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	
	<div class="col-6">
		<p class="text-danger"><form:errors path="event.*"/></p>
		<h4 class="my-4">Create an Event</h4>
		<form:form action="/events/create" modelAttribute="event" method="post">
			<div class="form-group row">
				<form:label class="col-sm-3 col-form-label" path="name">Name</form:label>
				<div class="col-sm-9">
					<form:input path="name" class="form-control"/>
				</div>
			</div>
			<div class="form-group row">
				<form:label class="col-sm-3 col-form-label" path="date">Date</form:label>
				<div class="col-sm-9">
					<form:input path="date" class="form-control" type="date"/>
				</div>
			</div>
			<div class="form-group row">
				<form:label class="col-sm-3 col-form-label" path="location">Location</form:label>
				<div class="col-sm-6">
					<form:input path="location" class="form-control"/>
				</div>
				<div class="col-sm-3">
		   			<form:select path="state" class="custom-select">
						<option value="AL">AL</option>
						<option value="AK">AK</option>
						<option value="AZ">AZ</option>
						<option value="AR">AR</option>
						<option value="CA">CA</option>
						<option value="CO">CO</option>
						<option value="CT">CT</option>
						<option value="DE">DE</option>
						<option value="DC">DC</option>
						<option value="FL">FL</option>
						<option value="GA">GA</option>
						<option value="HI">HI</option>
						<option value="ID">ID</option>
						<option value="IL">IL</option>
						<option value="IN">IN</option>
						<option value="IA">IA</option>
						<option value="KS">KS</option>
						<option value="KY">KY</option>
						<option value="LA">LA</option>
						<option value="ME">ME</option>
						<option value="MD">MD</option>
						<option value="MA">MA</option>
						<option value="MI">MI</option>
						<option value="MN">MN</option>
						<option value="MS">MS</option>
						<option value="MO">MO</option>
						<option value="MT">MT</option>
						<option value="NE">NE</option>
						<option value="NV">NV</option>
						<option value="NH">NH</option>
						<option value="NJ">NJ</option>
						<option value="NM">NM</option>
						<option value="NY">NY</option>
						<option value="NC">NC</option>
						<option value="ND">ND</option>
						<option value="OH">OH</option>
						<option value="OK">OK</option>
						<option value="OR">OR</option>
						<option value="PA">PA</option>
						<option value="RI">RI</option>
						<option value="SC">SC</option>
						<option value="SD">SD</option>
						<option value="TN">TN</option>
						<option value="TX">TX</option>
						<option value="UT">UT</option>
						<option value="VT">VT</option>
						<option value="VA">VA</option>
						<option value="WA">WA</option>
						<option value="WV">WV</option>
						<option value="WI">WI</option>
						<option value="WY">WY</option>
					</form:select>
		   		</div>
			</div>
			<div class="text-right">
				<button type="submit" class="btn btn-primary">Create</button>
			</div>
		</form:form>
	</div>
	
	
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>