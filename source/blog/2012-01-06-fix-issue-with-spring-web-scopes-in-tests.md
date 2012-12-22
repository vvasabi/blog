---
title: Fix Issue with Spring Web Scopes in Tests
cover_image: /images/springframework.png
date: 2012-01-06
tags: java, spring
---
Today I’m hit with the issue that Spring whines about the exception, “No Scope
registered for scope ‘request’,” when I try to run tests with request scoped
bean. Fortunately the fix is fairly easy.

READMORE

Discussions [here](http://stackoverflow.com/questions/2411343/request-scoped-beans-in-spring-testing)
suggest that the missing request and session scopes can be faked by using
`SimpleThreadScope`. So, the solution is simply to register the following scopes
in xml config:

```xml
<bean class="org.springframework.beans.factory.config.CustomScopeConfigurer">
	<property name="scopes">
		<map>
			<entry key="request">
				<bean class="org.springframework.context.support.SimpleThreadScope" />
			</entry>
			<entry key="session">
				<bean class="org.springframework.context.support.SimpleThreadScope" />
			</entry>
		</map>
	</property>
</bean>
```

Note that I have a different xml config file for testing, and obviously these
lines cannot be inserted into a config file that would be loaded at runtime.
Otherwise, things would be messed up.

Another note is that this method works with `@Autowired` dependencies. The
method posted on [Stack Overflow](http://stackoverflow.com/questions/2411343/request-scoped-beans-in-spring-testing)
does not.
