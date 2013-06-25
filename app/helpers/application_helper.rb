# coding: utf-8

module ApplicationHelper

def yymmddhhmm_ja( datetime )
  return '' if datetime.nil?
  datetime.strftime("%Y年%m月%d日 %H時%M分")
end


end
