package com.codingdojo.events.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.codingdojo.events.models.Event;

@Repository
public interface EventRepository extends CrudRepository<Event, Long>{
	@Query(value="select * from events where state=?1", nativeQuery=true)
	List<Event> findEventsInState(String state);
	
	@Query(value="select * from events where state!=?1", nativeQuery=true)
	List<Event> findEventsInOtherStates(String state);
}
