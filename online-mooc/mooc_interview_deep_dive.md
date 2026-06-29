# mooc 项目深挖版面试问答

这份内容不是按“背答案”写的，而是按大工程项目的真实面试方式写的：先把 mooc 的模块列清楚，再按模块逐个追问。你可以直接把它当成口述提纲来练，回答时尽量保持第一人称。

## 我先列一下 mooc 里比较核心的模块

从项目结构和业务定位看，这个平台可以拆成下面几大块：

1. 基础入口和公共能力：tj-gateway、tj-common、tj-api、xxl-job。
2. 用户与权限：tj-auth、tj-user。
3. 课程与学习主链路：tj-course、tj-learning、tj-exam、tj-remark。
4. 交易与支付：tj-trade、tj-pay、tj-promotion。
5. 消息与互动：tj-message、tj-chat、tj-live。
6. 数据与检索：tj-search、tj-data、tj-media。
7. 前端与运营支撑：tj-front、nacos、sql、Docker、Nginx、Sentinel、Redis、RabbitMQ、MyBatis、Redisson。

你面试时不需要把每个模块都背成百科，但至少要能讲清楚：哪个模块负责什么，模块之间怎么串，为什么要这么拆，以及高并发和一致性问题是怎么处理的。

## 你可以先这样开场

我做这个 mooc 项目时，最大的体会是它不是一个单纯的课程网站，而是一个在线职业技能培训的一站式教学与运营平台。课程售卖、学习闭环、交易支付、消息通知、搜索推荐、互动评论、直播和 AI 对话都被拆进了多个服务，再通过网关、公共组件和中间件串起来。做完之后，我对微服务拆分、跨服务调用、限流降级、分布式锁、异步化和数据一致性这些问题有了更系统的认识。

## 模块深挖问答

### 一、基础入口和公共能力

#### 1. 你先整体说一下这个项目的基础设施层是怎么搭的？

我会把它理解成“统一入口 + 通用能力 + 调度能力”三层。tj-gateway 负责统一入口、鉴权和流量治理，tj-common 沉淀了异常处理、分页封装、Redis、Redisson、Swagger、MyBatis 等公共能力，xxl-job 负责平台里的定时任务调度。这样做的好处是，业务服务不用重复写底层胶水代码。


#### 2. 你为什么觉得网关是这个项目里很关键的一层？

因为网关不是只负责转发，它承担了路由、认证、鉴权、限流、黑白名单和公共过滤逻辑。对这种多微服务平台来说，所有外部请求都先经过网关，才能把请求边界、权限边界和流量边界统一起来。这样后面的业务服务会更干净。


#### 3. tj-common 里你最关注哪几类通用能力？

我最关注的是统一响应、全局异常、分布式锁、MyBatis 自动配置和 Swagger 配置。它们看起来都不是业务本身，但实际上直接影响整个项目的开发效率和工程一致性。尤其是异常处理和 Redisson 配置，几乎所有服务都会用到。


#### 4. 你怎么理解项目里的全局异常处理？

我把它理解成“把内部异常翻译成统一的对外协议”。像 Sentinel 限流、Feign 调用失败、参数校验失败、数据库异常，这些在 CommonExceptionAdvice 里都会被统一转换成业务响应。这样前端和调用方就只关心 code 和 message，不需要直接面对底层异常栈。


#### 5. 为什么要区分网关请求和微服务内部请求的异常返回？

因为消费方不一样。网关请求更偏向给前端看，所以通常返回统一业务状态码；微服务之间调用更偏向给调用方做 fallback 或重试，所以更适合保留原始 HTTP 状态。这个设计能同时照顾用户体验和内部服务治理。


#### 6. 你为什么要引入 Redisson？

因为平台里有很多需要分布式互斥的场景，比如优惠券领取、定时任务竞争、并发写入、重复点击保护。纯 Redis 当然也能做锁，但 Redisson 提供了更完整的锁实现、续约机制和更清晰的 API，落地起来更稳，也更容易封装成通用能力。


#### 7. 你对分布式锁的理解是什么？

我把它理解成“在多实例部署下保证同一临界区同一时刻只有一个执行者”。它不是为了解决性能，而是为了一致性。落地时我最关注三点：锁粒度要小、持有时间要短、异常退出后不能把锁卡死。


#### 8. Sentinel 在这个项目里主要承担什么角色？

Sentinel 是整个系统的限流和熔断保护层。对外部高峰流量，它能保护核心接口不被打爆；对内部不稳定依赖，它能通过降级和熔断避免故障扩散。我觉得它本质上是在给系统兜底，不只是一个依赖包。


#### 9. 如果网关、服务内部和第三方依赖同时都可能触发限流，你会怎么区分处理？

我会把它们分成三层看。网关层更适合做入口级限流，避免流量直接灌进系统；服务内部更适合做资源级保护，防止某个热点接口拖垮整服务；第三方依赖则更适合做降级和兜底，避免外部不稳定把自己的主链路影响掉。


#### 10. 你怎么判断一个公共组件应该放到 tj-common，而不是放在某个业务服务里？

我会看它是不是跨多个服务复用、是不是只依赖稳定的基础能力、是不是和具体业务无强绑定。如果某个能力在多个模块里都要用，而且不依赖具体业务语义，那它就适合沉到 tj-common。反过来，如果它明显只服务于某个业务域，就不应该硬抽成公共能力。


### 二、用户与权限模块

#### 11. 你怎么理解 tj-auth 和 tj-user 的分工？

我理解成“tj-auth 负责身份和权限，tj-user 负责用户资料和账户体系”。前者更关注登录、令牌、认证和授权，后者更关注用户信息、角色、状态和基础档案。这样拆分后，鉴权逻辑不会散落在各个业务服务里。


#### 12. 你为什么觉得用户中心是整个平台的基础模块？

因为几乎所有业务都要依赖用户身份。无论是买课、学习、评论、支付还是消息，最终都要落到某个用户身上。只要用户体系不稳，其他业务链路都会受到影响，所以它是平台的基础锚点。


#### 13. 如果面试官问你“登录态是怎么贯穿整个系统的”，你会怎么答？

我会说，登录态通常先在鉴权中心完成认证，然后通过 token 或请求上下文传递给后续业务服务。网关先做统一拦截，后面的微服务再根据约定识别用户身份。这样既避免重复认证，也能让权限控制更统一。


#### 14. 你在权限和账号体系里最关注的工程问题是什么？

我最关注的是边界清晰和失效处理。比如 token 过期、权限变更、用户状态冻结，这些都要有明确的处理路径，不然系统很容易出现“看起来登录了，但实际上没有权限”的问题。


#### 15. 如果用户被封禁但 token 还没过期，你会怎么处理这个一致性问题？

我会把“登录态有效”和“业务权限有效”分开看。token 只代表身份凭证，并不代表业务权限一定还可用，所以业务请求还要再校验用户状态。这样即使 token 没过期，只要用户被封禁，系统也能在业务层及时拦住。


#### 16. 如果权限模型后期要从简单角色升级到更细的资源权限，你会怎么演进？

我会先把角色和权限的边界抽清楚，再把接口鉴权、菜单权限和数据权限分层处理。这样未来要扩展到资源级权限时，不需要推翻原来的登录体系，只要在原有认证之上再叠加更细的授权逻辑。


### 三、课程与学习主链路

#### 17. 课程中心、学习中心、考试中心、互动中心是怎么串起来的？

我会把它们理解成一个学习闭环。课程中心提供课程内容和章节结构，学习中心负责学习行为、进度和学习监督，考试中心负责测评和成绩记录，互动中心负责评论、点赞和问答。它们合在一起，才构成一个完整的学习平台。


#### 18. 你怎么理解课程中心的核心职责？

课程中心本质上是内容供给和商品化承载层。它负责课程的创建、编辑、展示、查询和资源组织。用户买课之前看到的是课程中心，买课之后学习链路还会继续依赖它。


#### 19. 学习中心为什么要单独拆出来？

因为“看课”和“学课”是两类不同的行为。课程中心关注内容，学习中心关注过程和结果，比如学习进度、播放记录、学习计划和学习监督。把它拆出来后，业务边界更清楚，也更方便做统计和优化。


#### 20. 你怎么看学习进度记录这类高频场景？

我会把它看成一个典型的高频、可合并写入场景。它不一定每次都要同步落库，而是可以先写缓存、合并请求，再通过异步方式统一持久化。这样既能保证体验，又能减轻数据库压力。


#### 21. 你为什么觉得考试中心也值得单独拆？

因为考试和课程、学习的语义已经不一样了。它更偏测评和结果沉淀，和课程展示、学习记录相比，数据模型和流程都更独立。拆开以后，后续做成绩统计、题目管理和考试策略会更清晰。


#### 22. 互动中心在这个平台里的价值是什么？

我觉得它的价值不是“加几个评论接口”，而是提升学习氛围和用户留存。点赞、评论、问答这些机制能让平台从单向内容输出变成双向互动。对教育类产品来说，这类功能很重要。


#### 23. 如果课程内容更新后，学习进度和互动数据要怎么保持一致？

我会尽量把课程内容版本和用户行为记录分开。课程更新不应该直接覆盖所有学习记录，而是通过版本号或变更事件去处理，这样既能保留历史行为，也能避免学习进度被课程变更误伤。


#### 24. 课程、学习、考试这三个模块如果统计口径不一致，你会怎么排查？

我会先看三者是不是使用了不同的时间窗口、课程版本和用户身份口径，再检查数据是否来自不同链路。很多统计偏差不是代码 bug，而是口径定义没统一，所以排查时我会先统一定义，再看实现。


### 四、交易与支付模块

#### 25. 交易中心和支付中心分别解决什么问题？

交易中心负责下单、订单状态、交易记录和订单流转，支付中心负责对接第三方支付、退款、支付结果查询和支付回调。前者管业务订单，后者管เงินจริง的支付动作。这样拆分后，职责不会混在一起。


#### 26. 你怎么看订单状态流转？

我觉得订单状态最适合用状态机思维去理解，而不是简单地写 if-else。每个状态只能走到合法的下一步，非法流转要直接拦住。这样做能减少支付回调、取消订单、退款这些场景里的边界错误。


#### 27. 交易和支付链路里最容易出问题的是什么？

最容易出问题的是状态一致性。比如订单创建、支付成功、回调通知、退款处理这些步骤一旦出现重复消息、重复回调或者丢消息，就容易导致订单状态和支付状态不一致。所以这一块一定要围绕幂等、补偿和可靠消息来设计。


#### 28. 你为什么觉得 tj-promotion 也应该和交易链路一起讲？

因为营销活动本质上是在影响交易转化。优惠券、折扣、活动和秒杀这类能力，最终都会影响订单创建和支付路径。也就是说，它不是单独的“活动模块”，而是交易前置的一部分。


#### 29. 你怎么理解高并发场景下的秒杀式优惠券处理？

我会优先考虑 Redis、Lua 脚本、分布式锁和异步落库的组合。Redis 负责快速拦截和原子校验，Lua 负责保证并发安全，后端再通过异步方式把结果落到数据库。这样既能扛住高并发，也能避免库存和领取记录错乱。


#### 30. 如果面试官问你怎么做幂等，你会怎么讲？

我会说幂等通常要从请求去重、状态校验、唯一约束和消息消费四个层面一起做。比如支付回调、退款通知、优惠券领取这种场景，必须保证重复请求不会产生重复结果。单靠某一个手段通常不够，得组合起来。


#### 31. 你怎么理解高并发写入优化？

我更倾向于把实时写和延迟落库拆开。比如一些高频、可合并的写请求，可以先写 Redis 或本地缓冲，再由定时任务异步持久化。对于必须即时一致的操作，再配合锁、乐观控制和幂等校验兜底。


#### 32. 如果异步落库失败了，你怎么保证数据不丢？

我会给异步链路补上重试、补偿和可观测性。比如把待落库的数据做成可追踪消息，失败后进入重试队列或者人工补偿流程。核心不是保证一次成功，而是保证失败后能被发现、能重放、能修复。


#### 33. 订单、优惠券、支付这三条链路如果都想做防重，你会怎么设计统一方案？

我会优先抽出统一的幂等框架，而不是每条链路各写一套。可以用业务唯一键、状态机校验、Redis 去重和数据库唯一约束组合起来，再让不同业务只配置自己的幂等标识和处理规则。


### 五、消息、直播、AI 和运营支撑

#### 34. 消息中心在这个项目里为什么重要？

因为它承接了很多异步通知和会话类能力。课程提醒、订单通知、互动提醒、私聊和群聊消息，都可以通过消息中心统一治理。把这类功能集中起来后，业务服务就不会到处散落消息发送逻辑。


#### 35. 你怎么理解 MQ 在这个项目里的价值？

MQ 的核心价值是削峰、异步和解耦。像支付回调通知、日志写入、积分变更、学习进度记录、优惠券发放这些场景，不一定要同步完成。改成异步后，主链路更快，系统也更抗高峰。


#### 36. 直播模块为什么会被放进这个平台？

因为直播能增强学习氛围和即时互动，尤其适合职业技能类培训。它让平台不仅有录播内容，还有实时讲解、互动和答疑。对一个教育平台来说，这会明显增强用户粘性。


#### 37. 你怎么看 tj-chat 这种 AI 能力模块？

我会把它看成平台的增值能力，而不是主业务本身。它更像是课程学习体验的增强层，比如智能问答、知识库检索、工具调用和个性化辅助。把它加进来，说明这个平台在往智能化学习服务演进。


#### 38. tj-data 在这个项目里主要体现什么价值？

我理解它主要是数据分析和运营可视化能力，比如流量统计、报表、大盘和日志分析。它把业务数据转成运营视角的数据，方便定位问题，也方便做决策。


#### 39. tj-media 为什么要单独拆？

因为媒体资源和普通业务数据的处理方式不一样。视频、图片、文件这些内容通常涉及上传、存储、审核、分片和分发，和课程、订单这种结构化数据并不一样。单独拆出来后，存储、转码和资源管理都更好做。


#### 40. 你怎么理解这个项目里的搜索模块？

我会把它看成内容索引层。课程、讲师、资料、标签这些数据适合被检索化，而不是每次都直接查主库。单独拆搜索后，能更好地支持全文检索、热词分析和推荐召回，也不会影响核心交易链路。


#### 41. 如果搜索索引和主库数据不一致，你会优先怀疑什么？

我会先怀疑同步链路，而不是先怀疑检索引擎本身。通常问题出在消息延迟、重建索引失败、写入幂等没处理好，或者主库更新和索引更新顺序不一致。排查时要先看数据流转链路，再看搜索结果。


#### 42. 直播、数据分析和媒资这三块都偏基础能力，你会怎么区分它们的职责边界？

我会把媒资看成资源存储和管理层，把直播看成实时分发和互动层，把数据分析看成运营观测和决策层。三者虽然都偏支撑，但解决的问题完全不同，不能混成一个服务。


### 六、通用工程化与整体总结

#### 43. 你为什么觉得这个项目适合拿来讲“微服务拆分”？

因为它的模块边界比较完整，能很清楚地看出哪些服务负责身份和权限，哪些负责课程和学习，哪些负责交易和支付，哪些负责消息和运营。面试时这特别好讲，因为你可以把“为什么拆”讲得很自然，而不是只背服务名。


#### 44. 你觉得这个项目里最容易被追问的技术点是什么？

我觉得最容易被追问的是“为什么这么拆服务”和“高并发场景怎么保证一致性”。如果只会说模块名，面试官一定会继续追问：为什么课程、学习、交易要拆开？为什么支付回调要异步？为什么 Redis 和 MQ 能解决问题？所以我会尽量讲清设计动机和取舍。


#### 45. 你最想在这个项目里强调的一个技术能力是什么？

我最想强调的是把复杂系统拆成可维护模块的能力。这个项目不是简单 CRUD 堆叠，而是要同时考虑业务域划分、公共能力抽取、跨服务调用、数据一致性和性能优化。我更习惯从系统视角去看问题，而不是只盯着某个接口。


#### 46. 如果让你重新总结这个项目，你会怎么收尾？

我会说这个 mooc 平台本质上是在做一件事：把课程销售、学习过程、交易支付和用户互动整合成一个闭环，并在这个过程中尽量把高并发、稳定性和工程化能力做扎实。对我来说，项目最大的价值不是“做了多少功能”，而是我真正理解了一个微服务平台怎么从基础设施到业务链路完整跑起来。


#### 47. 如果面试官追问你“这个项目最难的点是什么”，你会怎么答？

我会优先回答“不是某个单点功能，而是跨服务链路的一致性和治理”。因为真正难的地方往往不是把接口写出来，而是让多个模块在高并发、异步和失败场景下仍然能保持正确。


#### 48. 如果让你补一个你最想增强的模块，你会选哪个？

我可能会优先增强运营和分析侧，因为这类能力能直接反哺课程、交易和推荐。比如把学习行为、转化路径和用户画像做得更精细，就能进一步提升整个平台的留存和转化。


## 面试时你可以重点强调的点

1. 我不是只会讲业务名词，而是能把网关、鉴权、课程、学习、交易、支付、消息串成完整链路。
2. 我比较关注微服务拆分背后的边界和职责，而不是机械地把模块拆多。
3. 我会主动讲一致性、幂等、异步化、限流和分布式锁这些工程问题。
4. 如果对方继续追问，我能落到具体模块上展开，比如 tj-common、tj-gateway、tj-trade、tj-pay、tj-learning、tj-course、tj-message。

## 你可以临场替换的个人信息

如果你想让这份回答更像你本人，可以把下面三类信息换成你的真实经历：

1. 你最熟的业务模块，比如课程、交易、学习、消息或 AI。
2. 你最有把握讲清楚的一个技术点，比如分布式锁、Redis、MQ、Sentinel 或状态机。
3. 你做过的一个具体优化，比如缓存、异步写、日志埋点、查询性能优化或接口封装。

---

# 技术深挖面试：按简历技术栈逐项追问

> 以下内容按你简历中提到的技术栈顺序，模拟面试官逐层深挖。每个问题都是真实面试中可能被问到的，答案基于项目实际代码。

---

## 一、Spring Cloud Alibaba 微服务体系

### Q1: 你简历提到用 Nacos 做服务发现和配置中心，说一下 Nacos 在你们项目里具体是怎么用的？配置和服务发现分别承担什么职责？

**答：** 我们项目里所有微服务（15+ 个）都注册到 Nacos，Gateway 通过 `lb://service-name` 做负载均衡转发。配置方面，我们把公共配置抽取成 shared-config，每个服务在 `bootstrap.yml` 里声明自己要加载哪些共享配置：

```yaml
# 以 tj-gateway 的 bootstrap.yml 为例
spring:
  cloud:
    nacos:
      config:
        file-extension: yaml
        shared-configs:
          - data-id: shared-spring.yaml     # Jackson、MVC 配置
          - data-id: shared-redis.yaml      # Redis 连接池
          - data-id: shared-logs.yaml       # 日志格式
          - data-id: shared-mq.yaml         # RabbitMQ 连接
```

这个设计的核心思路是：**每个服务不再各自维护一份 Redis/MQ/日志配置，改一处所有服务生效**。服务发现用 `DEFAULT_GROUP`，配置中心用对应的 `data-id`。

另外 Nacos 配置也承载了业务开关，比如 `gateway-service.yaml` 里的 `tj.auth.excludePath` 配置了哪些路径不需要鉴权（如 `/courses/portal`、`/search`、`/notify/**`），这些路径列表可以动态调整而不用重启。


---

### Q2: Gateway 网关统一鉴权是怎么做的？能讲一下具体的过滤器链吗？

**答：** Gateway 里按 Order 排序挂了三个核心 GlobalFilter：

1. **RequestIdRelayFilter**（Order=`HIGHEST_PRECEDENCE`）：每个请求进来生成 UUID 作为 `requestId`，塞进 MDC 和下游请求头里。这样从网关到微服务、从日志到异常响应，全链路都有一个唯一追踪 ID。注意支付回调（`/ps/notify/**`）不加 `request-from: gateway` 头，因为那是外部第三方回调。

2. **LogTrackingFilter**（Order=`HIGHEST_PRECEDENCE`）：记录完整请求/响应日志。关键点：
   - 跳过文件上传（multipart/form-data）避免读 body 导致内存爆炸
   - 对响应体做装饰器模式（`ServerHttpResponseDecorator`），截获下游返回的 JSON，提取 `code`、`msg`、`requestId`
   - 从 JWT token 里解析出 userId 和 roleId 打入日志
   - 在 `doFinally` 里通过 `LogCollector` 异步写入 Redis 队列，再由定时任务批量发 MQ 到数据中心

3. **AccountAuthFilter**（Order=`1000`）：核心鉴权逻辑：
   - 先查路径是否在 `excludePath` 白名单里，是则直接放行
   - 从 `Authorization` header 解析 JWT token 拿到 userId
   - 把 `user-info` 头注入下游请求，让微服务不用再解析 token
   - 用 AntPathMatcher 做路径权限匹配
   - 同时用 Redis HyperLogLog 记录每日 UV：`SYSTEM:VISIT:DAILY:{yyyyMMdd}`


---

### Q3: 你提到 OpenFeign + RabbitMQ 实现跨服务同步/异步通信，什么场景用 Feign，什么场景用 MQ？给个具体例子。

**答：** 核心原则是：**需要即时响应、强一致性的用 Feign；能接受最终一致、需要削峰解耦的用 MQ**。

**Feign 场景举例：**
- `tj-chat` 里 Agent 调用 `ToolsService`，工具方法需要实时查课程信息，通过 `SearchClient`、`CourseClient` 这些 Feign 接口同步调用 `tj-search` 和 `tj-course`。因为用户等着看结果，不能异步。
- `tj-media` 判断用户是否有权限播放视频，需要 Feign 调 `tj-course` 查课节信息和 `tj-learning` 查购买状态。
- `tj-trade` 下单时，Feign 同步调 `tj-course` 校验课程是否存在和下架。

**MQ 场景举例：**
- 用户领取优惠券：Lua 脚本在 Redis 里原子校验+扣库存后，发 MQ 消息异步落 DB。领券接口的响应时间从"查DB+插入DB"的几十毫秒变成 Redis 操作的几毫秒。
- 支付成功通知：`tj-pay` 回调处理完后发 `PAY_SUCCESS` 消息，`tj-trade` 消费后执行状态机流转，`tj-learning` 消费后开通学习权限，`tj-search` 消费后更新课程销量。**一个支付事件触发三个微服务的后续动作，这就是 MQ 的解耦价值。**
- 网关日志采集：`LogCollector` 每 10 秒从 Redis 批量取 20 条日志发 MQ，`tj-data` 消费后写入 InfluxDB。


---

### Q4: Sentinel 熔断降级在你们项目里具体怎么配的？能举一个降级场景的例子吗？

**答：** Sentinel 在我们项目里分两层：

**基础设施层：** Nacos 共享配置 `shared-sentinel.yaml` 配置了 dashboard 地址 `localhost:8090` 和 client 端口 `8719`。同时 `shared-feign.yaml` 里开了 `feign.sentinel.enabled: true`，这意味着所有 Feign 调用都会自动被 Sentinel 包裹。

**异常处理层：** `tj-common` 里定义了 5 种 Sentinel 异常类型，code 从 2046 到 2050：
- `SENTINEL_FLOW(2046)` — QPS 超过阈值触发流控
- `SENTINEL_DEGRADE(2047)` — 慢调用比例/异常比例超过阈值触发熔断
- `SENTINEL_PARAMAS(2048)` — 热点参数限流（比如同一个商品 ID 被频繁查询）
- `SENTINEL_SYSTEM(2049)` — 系统负载/CPU 不满足要求
- `SENTINEL_AUTHORITY(2050)` — 授权规则不通过（黑白名单）

**具体降级例子：** 假设 `tj-search` 服务出现慢查询导致响应时间飙高，Sentinel 会检测到 Feign 调用的 RT 超过阈值，触发熔断。此时 Feign 调用不再打到 `tj-search`，而是直接走 fallback 返回降级响应（比如课程搜索返回空列表 + 一个降级提示），防止 `tj-search` 的故障扩散到 `tj-chat`、`tj-course` 等上游服务。这一切由 `CommonExceptionAdvice` 统一捕获 `SentinelException` 翻译成标准 JSON 响应给前端。


---

## 二、AI 智能服务中心（tj-chat）—— RAG、Agent、SSE、知识库

### Q5: 你简历写了 LangChain4j + Qdrant 实现 RAG，能讲一下你们 RAG 的完整链路吗？从课程内容入库到用户提问返回答案。

**答：** 整个 RAG 链路分两个阶段：**离线入库** 和 **在线检索增强**。

**离线入库（课程内容向量化）：**

1. **内容来源**：课程资料（讲义 Markdown、视频字幕 SRT/VTT、PDF 课件、题库）通过 `ContentParserUtils` 解析清洗——去掉时间戳、HTML 标签、图片链接等噪声
2. **分段策略**：用 `MarkdownSplitter` 基于 Flexmark AST 按标题层级（H2/H3）智能切分，每段保持一个独立知识点。同时支持按段落大小 fallback
3. **向量化存储**：每段生成 `TextSegment` 并附带元数据（`doc_id`、`course_id`、`section_id`、`content_type`），通过 `EmbeddingModel`（OpenAI 协议兼容的嵌入模型，实际用的 Ollama 本地部署）embed 后存入 Qdrant 的 `ai-chat` 集合

**在线检索增强：**

1. 用户提问后，先用同一个 `EmbeddingModel` 把问题向量化
2. 通过 Qdrant gRPC 客户端做 `searchAsync()`，支持 `user_id` 过滤（个人知识库）和 `limit=3` 控制召回数量
3. `QdrantEmbeddingUtils` 把 Qdrant 返回的 `ScoredPoint` 转成 LangChain4j 的 `EmbeddingMatch`，计算余弦相似度
4. 通过 `PromptBuilder.buildSystemMessage()` 把检索到的文本片段包进 `[SYS_CONTEXT_BEGIN]...[SYS_CONTEXT_END]` 标记，拼上用户原始问题，形成增强后的 prompt
5. 送入 `StreamingChatLanguageModel` 做流式生成

**关键设计**：`KnowledgeAdvisor` 的 System Prompt 明确约束 LLM "只参考上下文标记内的内容回答问题"，超出范围就诚实说不知道并建议补充资料。这比直接让 LLM 自由发挥更能避免幻觉。


---

### Q6: Agent 智能体和 Function Calling 是怎么实现的？有哪些工具？

**答：** 我们用 LangChain4j 的 `AiServices` + `@Tool` 注解来构建 Agent。

**工具注册：** `ToolsService` 类里用 `@Tool` 注解定义了 6 个工具函数：

| 工具 | 功能 | 调用的微服务 |
|------|------|-------------|
| `queryCourse(name)` | 按名称搜索课程 | Feign → `tj-search` (Elasticsearch) |
| `getCourseDetail(courseId)` | 查课程详情（价格、章节等） | Feign → `tj-course` |
| `getLearningProgress(courseId)` | 查用户学习进度（已完成/总章节） | Feign → `tj-learning` |
| `getQuestionsByIds(ids)` | 按 ID 列表查题目 | Feign → `tj-exam` |
| `searchCourseFaq(keyword)` | 搜索课程 FAQ | Feign → `tj-search` |

**Agent 组装：** 在 `AiConfig` 里通过 builder 模式创建 Agent：
```java
AiServices.builder(AssistantRedis.class)
    .chatLanguageModel(qwenChatModel)
    .streamingChatLanguageModel(qwenStreamingChatModel)
    .tools(toolsService)           // 注入工具
    .chatMemoryProvider(memoryProvider)  // 对话记忆
    .build();
```

**工作流程：** 当用户问"我学的 Java 课程学到哪了？"，LLM 先理解意图，自动调用 `queryCourse("Java")` 拿到课程 ID，再调用 `getLearningProgress(courseId)` 拿到进度，最后组织成自然语言回复。**LLM 自主决定调用哪些工具、按什么顺序调用，我们只需要定义工具签名和实现。**


---

### Q7: SSE 流式响应具体是怎么实现的？如果连接中断了你怎么处理？

**答：** SSE 实现用的是 Spring MVC 的 `SseEmitter`，核心流程：

```java
// ChatSessionServiceImpl.stream() 的简化逻辑
SseEmitter emitter = new SseEmitter(30 * 60 * 1000L);  // 30 分钟超时
TokenStream tokenStream = assistantRedis.stream(memoryId, message);
tokenStream.onNext(token -> {
    emitter.send(SseEmitter.event()
        .data(formatSseMessage(token), MediaType.TEXT_PLAIN)
        .name("message"));
});
tokenStream.onComplete(response -> {
    emitter.send(SseEmitter.event().data("[DONE]"));
    emitter.complete();
});
tokenStream.onError(emitter::completeWithError);
```

**几个关键设计：**

1. **`@NoWrapper` 注解**：因为全局 `WrapperResponseBodyAdvice` 会把所有返回值包成 `{code, msg, data}` JSON，但 SSE 需要 raw text/event-stream。`@NoWrapper` 标记后跳过包装。

2. **连接中断处理**：用 `AtomicBoolean isStreamCompleted` 追踪流状态，通过 `emitter.onCompletion()` 和 `emitter.onTimeout()` 回调做清理。即使客户端断开，服务端也能感知并释放 TokenStream 资源。

3. **超时兜底**：SseEmitter 设了 30 分钟超时，比 LangChain4j 的 TokenStream 超时宽松得多，确保正常对话不会因 SSE 超时中断。

4. **RAG 增强的流式对话**：`fileStream()` 方法在流式生成前先做向量检索（embed query → search Qdrant → build context），然后把增强后的 prompt 传给 `KnowledgeAdvisor`，后续流式生成逻辑完全一样。


---

### Q8: Redis + MySQL 双层对话记忆你是怎么设计的？为什么不直接用 Redis 或直接用 MySQL？

**答：** 核心类 `PersistentChatMemoryStore` 实现了 LangChain4j 的 `ChatMemoryStore` 接口，充当 Redis（热缓存）和 MySQL（持久化）之间的桥梁。

**读路径（`getMessages`）：**
1. 先查 Redis List：`chat:memory:{userId}:{sessionId}`
2. Redis 命中 → 直接反序列化返回（最快路径）
3. Redis 未命中 → 从 MySQL `chat_session` 表按 `segmentIndex` 升序查询，反序列化后返回

**写路径（`updateMessages`）：**
1. 过滤只存 `UserMessage` 和 `AiMessage`（SystemMessage 和 ToolResult 不存）
2. 通过 `PromptBuilder.extractOriginalMessage()` 把 RAG 增强 prompt 剥离，只存用户原始问题
3. `rightPush` 到 Redis List（LangChain4j 的 `MessageWindowChatMemory` 直接从 Redis 读）
4. 扔一个延迟持久化任务到 Redisson 的 blocking queue `chat-delay-queue`

**异步持久化（`DataDelayTaskHandler`）：**
- 后台线程阻塞等 10 秒（`DELAY_TASK_EXECUTE_TIME`）
- 取任务时做智能跳过：如果 Redis 队列在此期间又长了（用户还在说话），就跳过本轮，等下一轮
- 如果用户已经停下来了（队列长度 <= 入队时的 num），则批量写入 MySQL 并删除 Redis key

**为什么不只用一种存储：**
- **纯 Redis**：数据不持久，重启丢失，用户历史对话全没
- **纯 MySQL**：每次对话都写库，高并发聊天场景 MySQL 扛不住
- **双层方案**：对话过程中全部走 Redis（内存速度），用户停止说话后才异步落库。既保证了对话体验的流畅性，又有持久化兜底

**容错机制：** 落库失败会重试 3 次（10 秒间隔），3 次后进死信队列 `chat-dead-letter-queue` 供人工排查。


---

### Q9: 个人知识库功能是怎么实现的？文档上传后怎么变成可检索的知识？

**答：** 整个流程由 `MarkdownDocsServiceImpl` 和 `MarkdownSplitter` 配合完成：

**上传流程：**
1. `MarkdownController` 接收 `.md` 文件上传，校验格式和大小（<2MB）
2. 读 UTF-8 内容，存入 MySQL 的 `user_markdown_docs` 表
3. 进入分段向量化：`MarkdownSplitter.getMarkdownChunksByH(content, level)` 用 Flexmark 解析 AST，按指定标题层级（如 H2）切成独立的 `MarkdownChunk`
4. 对每个 chunk 创建 `TextSegment` 并附加元数据（`user_id`、`doc_id`），通过 `EmbeddingModel` embed 后存入 Qdrant
5. 用户在 `KnowledgeAdvisor` 对话时，检索会加 `user_id` 过滤，确保只能搜到自己的知识库

**核心设计考量：**
- **分段质量比向量模型更重要**：按标题切分保证了每个 chunk 是一个完整知识点，而不是硬按 512 token 截断导致语义断裂
- **用户隔离**：Qdrant 检索时通过 `user_id` 过滤，保证知识库私有性
- **更新和删除**：更新文件时重新分段+重新向量化；删除文件时通过 Qdrant gRPC 的 `deleteAsync()` 按 `doc_id` 清理


---

## 三、Redis/Redisson 分布式缓存与锁 —— 优惠券秒杀

### Q10: 优惠券秒杀的高并发方案，你能详细讲一下从第一版到最终版的演进过程吗？

**答：** 这个模块经历了 5 次迭代，是项目中我最能讲清楚的一个演进案例：

**第一版：JVM synchronized**
- `UserCouponServiceImpl`：`synchronized (userId.toString().intern())`
- 问题：只锁单 JVM，多实例部署时完全无效。String.intern() 还可能导致常量池膨胀。

**第二版：手动 Redis SETNX 锁**
- `UserCouponRedisServiceImpl`：自己封装 `RedisLock` 用 `setIfAbsent` + TTL
- 问题：锁的续约需要自己管理，锁释放逻辑不健壮（可能误删别人的锁）

**第三版：Redisson 分布式锁**
- `UserCouponRedissonServiceImpl`：`redissonClient.getLock(key).tryLock()`
- 优势：watchdog 自动续约，不需要手动管理 lease time
- 问题：锁的争抢本身有开销，高并发下大量请求在等锁

**第四版：自定义 @MyLock 注解 + AOP + 策略模式**
- `UserCouponRedissonCustomServiceImpl`：把分布式锁抽象成注解
- `MyLockFactory` 支持 4 种锁类型：可重入锁、公平锁、读锁、写锁
- `MyLockStrategy` 支持 5 种失败策略：快速失败、重试后失败、跳过等
- `MyLockAspect` 通过 SpEL 解析锁名，支持动态 key（如 `lock:coupon:uid:#{userId}`）
- 这一版更多是框架层面的抽象，但锁的本质问题还在

**第五版（最终）：Redis Lua 脚本**
- `UserCouponLuaServiceImpl`：直接用 Lua 脚本在 Redis 服务端原子执行所有校验

```lua
-- receive_coupon.lua 的核心逻辑
if(redis.call('exists', KEYS[1]) == 0) then return 1 end              -- 活动未开始
if(tonumber(redis.call('hget', KEYS[1], 'totalNum')) <= 0) then return 2 end  -- 库存不足
if(redis.call('time')[1] > redis.call('hget', KEYS[1], 'issueEndTime')) then return 3 end  -- 已结束
if(redis.call('hget', KEYS[1], 'userLimit') < redis.call('hincrby', KEYS[2], ARGV[1], 1)) then return 4 end  -- 超限
redis.call('hincrby', KEYS[1], "totalNum", "-1")  -- 扣库存
return 0  -- 成功
```

**为什么 Lua 脚本是最优解：** Lua 在 Redis 里是原子执行的，相当于把"校验 + 扣库存"打包成一个不可分割的操作。不需要分布式锁，没有锁竞争开销，也没有死锁风险。领券接口的 QPS 从加锁方案的几百提升到几千。

**异步落库：** Lua 成功后不发呆等 DB 写入，而是发 MQ 消息让 `PromotionCouponHandler` 消费端异步写入 `user_coupon` 表，同时用 `UPDATE coupon SET issue_num = issue_num + 1 WHERE id = #{id} AND issue_num < total_num` 的乐观锁做二次校验，确保库存一致性。


---

### Q11: 你项目里的 @MyLock 自定义注解是怎么设计的？SpEL 表达式怎么解析的？

**答：** `@MyLock` 是我在演进过程中做的一个通用分布式锁框架，虽然最终秒杀场景用 Lua 替换了，但这个框架在项目中其他需要分布式锁的场景仍然适用。

**注解定义：**
```java
@MyLock(
    name = "lock:coupon:uid:#{userId}",    // 支持 SpEL 动态锁名
    lockType = MyLockType.RE_ENTRANT_LOCK,  // 锁类型
    lockStrategy = MyLockStrategy.FAIL_AFTER_RETRY_TIMEOUT,  // 失败策略
    waitTime = 1, leaseTime = -1            // 等待时间/租约（-1 用 watchdog）
)
```

**锁工厂（`MyLockFactory`）：** 用策略模式 + 枚举映射，`RE_ENTRANT_LOCK → redissonClient.getLock(name)`, `FAIR_LOCK → redissonClient.getFairLock(name)`, `READ_LOCK / WRITE_LOCK → redissonClient.getReadWriteLock(name).readLock()/writeLock()`

**AOP 切面（`MyLockAspect`）：**
1. 从 `@MyLock.name()` 取锁名模板
2. 用 SpEL 解析器 `ExpressionParser` 解析模板中的 `#{}` 表达式，从方法参数中取值（比如 `#{userId}` 从参数 `Long userId` 取值）
3. 还支持静态方法调用：`T(com.tianji.common.utils.UserContext).getUser()`
4. 根据 `lockType` 从工厂拿锁，根据 `lockStrategy` 决定 tryLock 的行为
5. `try-finally` 保证解锁


---

### Q12: Redis 在你们项目里还有哪些使用场景？除了缓存和锁。

**答：** 除了缓存和分布式锁，Redis 在项目中还有这些用法：

1. **HyperLogLog 统计 UV**：Gateway 的 `AccountAuthFilter` 每天用 `PFADD SYSTEM:VISIT:DAILY:{yyyyMMdd} userId` 记录独立访客，几乎零内存开销
2. **ZSET 存储搜索历史**：`search:history:{userId}` 按时间戳排序，保留最近 10 条
3. **BitMap 兑换码去重**：`coupon:code:map` 按序列号偏移量标记兑换码是否已使用，极致节省内存
4. **ZSET 兑换码范围映射**：`coupon:code:range` 把序列号范围映射到对应的优惠券 ID，支持 O(logN) 查找
5. **Redisson 延迟队列**：`chat-delay-queue` 和 `chat-retry-blocking` 实现对话记忆的延迟异步持久化
6. **List 作为日志缓冲**：`api:logs:queue` 暂存网关日志，10 秒批量消费，避免每次请求都写 MQ
7. **Hash 存储运营看板数据**：数据中心看板的今日数据、Top10、待办提醒都缓存到 Redis
8. **分布式信号量控制并发**：`RedissonClient` 的其他数据结构在优惠券发放的并行计算中使用
9. **Pipeline 批量写入**：`CouponServiceImpl.beginIssueBatch()` 用 `executePipelined` 一次网络往返写入所有优惠券的 Hash 数据


---

## 四、Elasticsearch 全文检索与课程推荐

### Q13: 课程搜索具体是怎么实现的？用了什么查询策略？

**答：** 课程搜索在 `tj-search` 模块，基于 Elasticsearch 的 `RestHighLevelClient` 实现。

**索引设计：** 课程文档 `course` 包含字段：`name`（课程名）、`categoryIdLv1/Lv2/Lv3`（三级分类）、`free`（是否免费）、`type`（课程类型）、`sold`（销量）、`price`、`score`、`teacher`、`publishTime` 等。

**查询策略（`buildBasicQuery`）：**
1. **关键词搜索**：用 `matchPhraseQuery` 精准匹配课程名，不是 `matchQuery` 分词匹配，因为我们希望用户搜"Java"时返回包含"Java"的课程名而不是分词后的碎片结果
2. **过滤条件叠加**：`categoryIdLv1/2/3` 用 `termQuery` 精确过滤，`free` 布尔过滤，`updateTime` 范围过滤。全部加到 BoolQuery 的 `filter` 子句里（不影响评分，性能更好）
3. **排序**：支持按 `sold`（销量）、`publishTime`（发布时间）、`price`（价格）排序
4. **高亮**：对 `name` 字段做高亮，把命中的关键词用 `<em>` 标签包裹后替换原始值返回

**自动补全（Suggest）：** 用 Spring Data Elasticsearch 的 `@CompletionField` 在 `suggestinfo` 索引导入了三种匹配方式——标准分词、全拼、首字母拼音。用户输入"ja"可以匹配"Java"课程，输入"java"可以匹配，输入拼音"java"也能匹配。


---

### Q14: 搜索索引和数据库怎么保持同步？索引延迟了怎么办？

**答：** 同步走的是 MQ 异步消息，不是 CDC 也不是定时扫表。

**同步链路：**
- 课程上架 → `tj-course` 发 `COURSE_UP_KEY` 消息 → `tj-search` 的 `CourseEventListener` 消费 → 调 `CourseClient` 查最新课程信息 → 写入 ES `course` 索引 + `suggestinfo` 索引
- 课程下架/过期 → 发 `COURSE_DOWN_KEY` / `COURSE_EXPIRE_KEY` → 删 ES 文档
- 支付成功/退款 → 发 `ORDER_PAY_KEY` / `ORDER_REFUND_KEY` → `OrderEventListener` 用 Painless 脚本增量更新 `sold` 字段（`ctx._source.sold += params.count`），而非全量覆盖

**为什么不用 CDC：** 我们业务数据在 MySQL，但 MySQL binlog 解析（如 Canal）引入额外的组件和运维复杂度。MQ 消息的语义更业务化（"课程上架"vs"course 表 status 字段从 0 变 1"），而且和已有的 RabbitMQ 基础设施复用。

**对延迟的态度：** 课程搜索场景允许秒级延迟。如果索引同步失败，MQ 有 ACK + 重试机制。极端情况下可以通过 XXL-Job 跑全量重建索引。


---

## 五、RabbitMQ 消息队列

### Q15: RabbitMQ 在你们项目里的使用场景有哪些？你们怎么保证消息可靠性？

**答：** RabbitMQ 在项目中承担了 **削峰、解耦、异步** 三个角色，具体场景：

| 场景 | 交换机 | 路由 Key | 消费者 | 目的 |
|------|--------|----------|--------|------|
| 支付成功 | `PAY_EXCHANGE` | `PAY_SUCCESS` | `tj-trade`, `tj-learning`, `tj-search` | 一事件多消费 |
| 退款变更 | `PAY_EXCHANGE` | `REFUND_CHANGE` | `tj-trade` | 退款状态同步 |
| 领券落库 | `PROMOTION_EXCHANGE` | `COUPON_RECEIVE` | `tj-promotion` | 异步持久化 |
| 课程上下架 | `COURSE_EXCHANGE` | `COURSE_UP/DOWN_KEY` | `tj-search` | 索引同步 |
| 订单支付 | `ORDER_EXCHANGE` | `ORDER_PAY_KEY` | `tj-learning`, `tj-search` | 开通学习权限+更新销量 |
| 订单退款 | `ORDER_EXCHANGE` | `ORDER_REFUND_KEY` | `tj-learning`, `tj-search` | 回收学习权限 |
| 网关日志 | `DATA_EXCHANGE` | `DATA_LOG_KEY` | `tj-data` | 日志采集入库 |
| 运营数据 | `DATA_EXCHANGE` | `DATA_TODO/ORDER/...` | `tj-data` | 看板数据更新 |
| 延迟查单 | `ORDER_EXCHANGE` | `ORDER_DELAY_KEY` | `tj-trade` | TTL 延迟队列查支付状态 |

**消息可靠性保证：**
1. **生产者确认（Publisher Confirm）**：MQ 配置里开启了 confirm 模式，消息落盘才 ACK
2. **消费者手动 ACK**：所有 `@RabbitListener` 默认自动 ACK，关键业务改为手动 ACK，处理完才确认
3. **持久化**：队列声明 `durable = "true"`，消息 `deliveryMode=2`（持久化到磁盘）
4. **重试 + 死信**：消费失败后重试，超过重试次数进死信队列


---

## 六、Seata 分布式事务

### Q16: Seata 在你们项目里具体用在什么场景？AT 模式怎么保证回滚的？

**答：** 我们用 Seata AT 模式，注册中心用 Nacos，配置存在 `shared-seata.yaml`。

**使用场景：** `@GlobalTransactional` 标注在三个关键方法上：

1. **`OrderServiceImpl.placeOrder()`**：下单流程涉及多个操作——校验课程状态（调 `tj-course`）、创建订单（`tj-trade` 本地库）、删除购物车（`tj-trade` 本地库）、核销优惠券（调 `tj-promotion`）。如果优惠券核销失败，订单创建和购物车删除都要回滚。

2. **`OrderServiceImpl.cancelOrder()`**：取消订单涉及订单状态变更 + 优惠券退还（调 `tj-promotion`）。如果退还优惠券失败，订单状态要回滚。

3. **`OrderStateListenerImpl.closeTransition()`**：订单关闭状态机的 transition 里标记了 `@GlobalTransactional`，因为关单同时要退还优惠券。

**AT 模式原理简述：** Seata 代理数据源，在本地事务提交前拍一个"前置快照"（before image），提交后拍一个"后置快照"（after image）。如果全局事务需要回滚，Seata 用 before image 的 UNDO_LOG 反向生成 SQL 还原数据。

**我们为什么用 AT 而不是 TCC：** AT 对业务侵入最小，不需要写 confirm/cancel 逻辑。而课程下单这类场景不是超高并发，AT 的性能损失（额外的 UNDO_LOG 写入）完全可以接受。


---

## 七、XXL-Job 分布式任务调度

### Q17: XXL-Job 在你们项目里跑了哪些定时任务？分片广播是怎么用的？

**答：** XXL-Job 的任务分布在多个微服务里：

| 任务 | 所属服务 | 分片 | 功能 |
|------|----------|------|------|
| `couponIssueJobHandler` | tj-promotion | ✅ 分片 | 定时发券：扫描到期未发的券，分片并行写入 Redis |
| `couponExpireJobHandler` | tj-promotion | ✅ 分片 | 过期优惠券状态更新 |
| `couponDataJobHandler` | tj-promotion | ❌ | 推送待审核优惠券数量到数据中心 |
| `refundRequestJobHandler` | tj-trade | ❌ | 扫描已审批的退款申请，分页调支付网关退款 |
| `payOrderCheckHandler` | tj-pay | ❌ | 轮询待支付订单的支付状态 |
| `refundOrderCheckHandler` | tj-pay | ❌ | 轮询退款订单的退款状态 |
| `logStatisticsToMySQL` | tj-data | ❌ | 每天凌晨从 InfluxDB 读昨日日志做统计汇总写 MySQL |
| `logAnalysis` | tj-data | ❌ | 分析课程浏览日志，构建用户画像和课程画像 |

**分片广播的用法（以发券为例）：**
```java
@XxlJob("couponIssueJobHandler")
public void handleCouponIssueJob() {
    int index = XxlJobHelper.getShardIndex() + 1;   // 分片序号，从 1 开始
    int size = Integer.parseInt(XxlJobHelper.getJobParam()); // 每片大小
    Page<Coupon> page = couponService.lambdaQuery()
            .eq(Coupon::getStatus, CouponStatus.UN_ISSUE)
            .le(Coupon::getTermBeginTime, LocalDateTime.now())
            .page(new Page<>(index, size));  // index 就是 page number
    // ...
}
```

**设计思路**：3 个执行器实例，分片序号分别是 1/2/3，每片取不同 page 的数据。这样不用加锁，每个实例只处理自己分到的数据，天然避免重复执行。


---

## 八、腾讯云 VOD —— 视频点播、加密、审核

### Q18: 腾讯云 VOD 的视频加密和防盗链是怎么实现的？

**答：** 视频安全分两层：

**播放签名（`getPlaySignature`）：**
- 用 HMAC-SHA1 生成上传签名用于客户端直传
- 播放时生成 JWT 签名，payload 包含：`appId`、`fileId`、`currentTimeStamp`、`pcfg`（DRM 播放器配置 `basicDrmPreset`）、`urlAccessInfo`
- 签名用 `urlKey` 做密钥，服务端签发后返回给前端，前端 SDK 用这个签名才能解密播放
- 免费试看场景：`urlAccessInfo` 里设 `exper` 参数（试看时长，单位分钟），到期后播放器自动停止

**业务流程（`MediaServiceImpl.getPlaySignatureBySectionId`）：**
1. 通过 Feign 调 `tj-course` 查课节信息
2. 通过 Feign 调 `tj-learning` 查用户是否已购买该课程
3. 已购买 → 生成无限制播放签名
4. 未购买 → 检查课节是否支持试看（`sectionInfo.getTrailer()`），支持则生成带时长限制的签名，不支持则抛 `ForbiddenException`

**VOD 任务流（Procedure）：** 上传时指定 `procedure: "wisehub-base"`，腾讯云自动触发转码 + 雪碧图 + AI 审核。`PullEventTask` 每 10 秒轮询事件，收到 `ProcedureStateChanged` 事件后解析结果（时长、分辨率、封面图 URL），更新本地 `media` 表。


---

## 九、支付宝/微信支付 —— 回调处理与幂等

### Q19: 支付回调你怎么保证幂等？如果同一笔订单收到两次支付成功回调怎么办？

**答：** 双重幂等保护：**Redis 分布式锁 + DB 乐观锁**。

**第一层：分布式锁**
```java
@Lock(name = "pay:notify:payOrderNo:#{tradingOrderNo}")
private PayOrder checkNotifyData(Long tradingOrderNo, Integer amount, LocalDateTime successTime) {
    // ...
}
```
回调进入时先按交易单号加 Redis 分布式锁。同一笔订单的并发回调被串行化。

**第二层：DB CAS 乐观锁**
```java
// markPayOrderSuccess() 的核心 SQL
UPDATE pay_order 
SET status = 3, notify_status = 1, pay_success_time = ?
WHERE id = ? AND status IN (0, 1)
```
即使分布式锁失效了，数据库的 `WHERE status IN (0, 1)` 条件保证只有第一次更新会成功（affected rows = 1），后续更新 affected rows = 0 直接忽略。

**金额校验：** 还会校验回调里的支付金额是否等于订单金额，防止金额篡改。

**签名验证：**
- 支付宝：`Factory.Payment.Common().verifyNotify(request)` 验证签名
- 微信：用 `CertificatesManager` 获取验证器，`NotificationHandler` 验证签名 + 解密回调体

**通知下游：** 幂等校验通过后，发 MQ 消息 `PAY_SUCCESS` 到 RabbitMQ，`tj-trade` 的 `PayMessageHandler` 消费后触发订单状态机流转。


---

## 十、Spring State Machine —— 订单状态机

### Q20: 为什么用状态机而不是 if-else？具体状态流转是怎样的？

**答：** 订单状态有 6 个：`NO_PAY(1)` → `PAYED(2)` / `CLOSED(3)`，`PAYED(2)` → `FINISHED(4)` / `ENROLLED(5)` / `REFUNDED(6)`。

**不用 if-else 的原因：**
- 非法状态流转难控制：比如从 `CLOSED` 直接跳到 `PAYED` 这种逻辑错误，if-else 很容易漏掉
- 状态越加越多后，if-else 变成意大利面条
- 状态机的 transition 自带"只有合法路径才能走"的语义

**状态机配置（`OrderStateMachineConfig`）：**
```
NO_PAY --(PAYED)--> PAYED       // 支付成功
NO_PAY --(CLOSED)--> CLOSED     // 超时取消/用户取消
PAYED --(REFUNDED)--> REFUNDED  // 退款完成
```

**状态机触发流程（`OrderServiceImpl.sendEvent`）：**
1. `synchronized` 方法保证同一订单不会并发发送事件
2. `stateMachineMemPersister.restore()` 从内存恢复状态机当前状态
3. `sendEvent()` 触发 transition
4. `stateMachineMemPersister.persist()` 持久化新状态
5. 保证状态机在一个完整生命周期内状态一致

**监听器（`OrderStateListenerImpl`）：**
- `@OnTransition(source = "NO_PAY", target = "PAYED")`：更新订单状态 → 标记订单详情为成功 → 发 MQ 通知开通课程
- `@OnTransition(source = "NO_PAY", target = "CLOSED")`：用 `@GlobalTransactional`（Seata）包裹 → CAS 更新订单状态 → 退还优惠券


---

## 十一、数据中心（tj-data）—— InfluxDB、推荐算法、监控

### Q21: 为什么用 InfluxDB 存日志而不是 Elasticsearch 或 MySQL？

**答：** 核心考量是 **写入吞吐** 和 **时序特性**：

1. **网关日志是典型的时序数据**：每条日志都带时间戳，查询模式是按时间范围聚合（日活、访问量趋势），不是随机的关键词搜索。InfluxDB 对时序写入和聚合做了深度优化。
2. **写入性能**：InfluxDB 的 LSM-Tree 存储引擎对高吞吐写入非常友好。虽然这个项目规模不大，但设计上如果之后网关 QPS 上去，InfluxDB 比 MySQL 更适合日志场景。
3. **7 天保留策略**：`docker-compose.yml` 里 InfluxDB 挂载到宿主机，配合 `rp_point` 保留策略，日志自动过期，不用手动清理。
4. **和 Elasticsearch 的分工**：ES 负责课程全文搜索（需要倒排索引和相关性评分），InfluxDB 负责时序日志聚合（需要高效的时间范围扫描和聚合函数）。各司其职。


---

### Q22: 协同过滤 + 特征权重混合推荐算法具体怎么做的？

**答：** 实际上项目中实现了两种算法：

**特征权重推荐（`FeatureBasedRecommendationAlgorithm`，当前在用）：**
三个特征加权打分：
- 省份匹配（权重 0.3）：用户省份和课程面向省份是否匹配
- 性别匹配（权重 0.2）：用户性别和课程目标用户性别是否匹配
- 偏好匹配（权重 0.5）：用户的免费/付费偏好和课程类型是否匹配

每个特征匹配得 1 分，不匹配得 0 分（数据缺失时默认 0.5 分）。加权求和后排序，取 Top 3。

**协同过滤（`CollaborativeFilteringRecommendationAlgorithm`，已实现但未接入）：**
基于用户相似度：
- 性别相似度（权重 0.2）
- 省份相似度（权重 0.3）
- 课程偏好相似度（权重 0.5，用 Jaccard 系数：`|A ∩ B| / (|A| + |B| - |A ∩ B|)`）

找到和目标用户最相似的 K 个用户，推荐他们学过但目标用户没学过的课程。

**服务入口**：`RecommendServiceImpl.featureRecommend()` — 从 MySQL 取 `UserProfile` 和 `CourseProfile`，调算法算分，返回推荐课程 ID 列表。前端搜索页的"猜你喜欢"就是调的这个接口，未登录用户则降级为热门课程。


---

### Q23: 简历提到 Prometheus + Grafana + SkyWalking 全链路监控，代码里具体怎么集成的？

**答：** 实话说，当前代码里 Prometheus、Grafana、SkyWalking 的依赖和配置没有直接出现在项目源码中。

但它们在项目基础设施层的定位很清晰：
- **SkyWalking** 在微服务启动时通过 Java Agent（`-javaagent:skywalking-agent.jar`）挂载，自动采集服务间的调用链（Feign、MQ、DB 访问），不需要代码侵入
- **Prometheus** 通常通过 Spring Boot Actuator + Micrometer 暴露 `/actuator/prometheus` 端点，或者通过 JMX Exporter 抓取 JVM 指标
- **Grafana** 配置 Prometheus 做数据源，导入 JVM Micrometer Dashboard 和 SkyWalking 的调用链 Dashboard

在项目目前的实际监控体系中，**InfluxDB 承担了业务数据监控的角色**（网关日志 → InfluxDB → 运营看板），**Sentinel Dashboard 承担了流量监控的角色**（QPS、RT、熔断状态），而 Prometheus + Grafana + SkyWalking 更多是基础设施层的可观测性保障。面试时我会诚实地说明这一点，而不是假装什么都配了。

---

## 十二、综合设计问题

### Q24: 如果让你设计一个"用户下单 → 支付 → 开通课程"的全链路，你会怎么保证数据一致性？

**答：** 这是一个跨多个微服务的分布式事务场景，我会分层处理：

**1. 正常流程（最终一致性 + MQ）：**
```
用户下单 → tj-trade 创建订单（本地事务）
         → 发 MQ 延迟消息（30 分钟后检查支付状态）
用户支付 → 支付宝/微信回调 tj-pay
         → tj-pay 幂等处理 + 发 PAY_SUCCESS 到 MQ
         → tj-trade 消费 → 状态机 NO_PAY → PAYED
         → tj-learning 消费 → 开通学习权限
         → tj-search 消费 → 更新课程销量
```

**2. 订单创建 + 优惠券核销（强一致性 + Seata）：**
- 下单和核销优惠券必须在同一个全局事务里。如果核销失败，订单回滚。这是 `@GlobalTransactional` 的场景。

**3. 异常补偿（定时任务兜底）：**
- `payOrderCheckHandler`（XXL-Job）：轮询超过 N 分钟未支付的订单，调用第三方支付网关查询真实状态。如果用户已付款但回调丢失，手动补发 `PAY_SUCCESS` 消息。
- `refundOrderCheckHandler`：轮询退款中的订单，查询第三方退款状态。
- `RefundJobHandler`：轮询已审批但未发起退款的申请，重新调用支付网关。

**4. 对账：**
- 微信支付有 `downloadMerchantBill()` 接口，可以下载交易账单做日终对账。支付宝也有类似的对账单接口。

**核心思想：能用最终一致性的不硬上强一致性，MQ + 补偿任务覆盖 99% 场景，Seata 只用在真正需要强一致性的关键步骤。**


---

### Q25: 这个项目让你对微服务架构最大的认知是什么？如果重来你会改什么？

**答：** 最大的认知是：**微服务拆分的核心不是"拆得多"，而是"拆得对"。**

这个项目 15+ 个服务，但每个拆分都有明确的业务边界——课程、学习、交易、支付、营销、搜索、数据，都是独立业务域。拆完之后跨服务调用的复杂度（分布式事务、链路追踪、日志聚合）才是真正的挑战，而这些挑战在项目初期往往被低估。

**如果重来我会改进的地方：**
1. **API 网关的限流粒度**：目前 Sentinel 规则主要在 dashboard 手动配置，可以配合 Nacos 做动态规则管理，业务高峰自动降级非核心接口
2. **搜索服务**：目前用 RestHighLevelClient 手写 DSL，维护成本高。Spring Data Elasticsearch 的 `ElasticsearchRepository` 已经在 `SuggestIndexRepository` 里用了，可以推广到 `CourseRepository`
3. **数据中心的实时性**：日志从 Gateway → Redis → MQ → InfluxDB 的链路延迟在秒级，如果未来要做实时大屏，可以考虑 Gateway 直接写 Kafka 再消费到 InfluxDB
4. **AI 模块**：Agent Function Calling 目前是硬编码 6 个工具，可以做成工具注册中心，支持运营人员动态上下线工具而不用重启服务
