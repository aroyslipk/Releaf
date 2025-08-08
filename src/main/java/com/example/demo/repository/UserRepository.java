package com.example.demo.repository;

import com.example.demo.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.QueryHints;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import jakarta.persistence.QueryHint;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    Optional<User> findByEmail(String email);
    
    Boolean existsByEmail(String email);
    
    List<User> findByGroupId(Long groupId);
    
    @Query("SELECT u FROM User u WHERE u.xpPoints >= :xpPoints")
    List<User> findUsersWithXpGreaterThanOrEqual(@Param("xpPoints") Integer xpPoints);
    
    @Query("SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.completedTasks LEFT JOIN FETCH u.group LEFT JOIN FETCH u.unlockedRewards ORDER BY u.xpPoints DESC")
    @QueryHints({@QueryHint(name = "org.hibernate.cacheable", value = "true")})
    List<User> findAllOrderByXpPointsDesc();
    
    @Query("SELECT COUNT(ct) FROM User u JOIN u.completedTasks ct WHERE u.id = :userId")
    Long countCompletedTasksByUserId(@Param("userId") Long userId);

    @Query("SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.completedTasks WHERE u.id = :userId")
    Optional<User> findByIdWithCompletedTasks(@Param("userId") Long userId);
    
    @Query("SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.completedTasks LEFT JOIN FETCH u.group")
    List<User> findAllWithDetails();

    @Query("SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.completedTasks LEFT JOIN FETCH u.group WHERE LOWER(u.name) = LOWER(:name)")
    List<User> findByNameEqualsIgnoreCase(@Param("name") String name);
    
    @Query("SELECT COUNT(u) > 0 FROM User u WHERE u.id = :userId AND u.group.id = :groupId")
    Boolean existsByUserIdAndGroupId(@Param("userId") Long userId, @Param("groupId") Long groupId);
    
    @Query("SELECT u FROM User u WHERE u.group.id = :groupId")
    List<User> findAllByGroupId(@Param("groupId") Long groupId);
}

