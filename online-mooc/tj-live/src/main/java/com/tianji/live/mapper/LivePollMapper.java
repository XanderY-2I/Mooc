package com.tianji.live.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tianji.live.domain.po.LivePoll;
import org.apache.ibatis.annotations.Update;

public interface LivePollMapper extends BaseMapper<LivePoll> {
    @Update("UPDATE live_poll SET total_votes = total_votes + 1 WHERE id = #{pollId}")
    void incrementTotalVotes(Long pollId);
}
