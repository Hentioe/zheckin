import React from "react";
import { Link } from "react-router-dom";
import useSWR from "swr";
import unfetch from "unfetch";

const Item = ({ to, iconUrl, text }) => {
  return (
    <Link
      className="px-4 py-2 m-2 rounded-full hover:bg-blue-200 flex items-center flex-no-wrap"
      to={to}
    >
      <img
        className="flex-initial h-10 w-10 rounded-full inline"
        src={iconUrl}
      />
      {text && (
        <span
          className="hidden md:inline ml-4 text-xl font-medium"
          style={{
            overflow: "hidden",
            textOverflow: "ellipsis",
            whiteSpace: "nowrap"
          }}
        >
          {text}
        </span>
      )}
    </Link>
  );
};

export default ({ className }) => {
  const { data, error } = useSWR("/console/api/clubs/joined", url =>
    unfetch(url).then(r => r.json())
  );

  if (error) return <div>获取圈子列表出错。</div>;
  if (!data) return <div>圈子列表加载中...</div>;

  const { clubs } = data.data;

  return (
    <header className={className}>
      <Item
        iconUrl={CURRENT_USER.avatar.replace("{size}", "im")}
        text="个人设置"
        to="/console/settings"
      />
      {clubs.map(club => (
        <Item
          key={club.id}
          to={`/console/histories/clubs/${club.id}`}
          iconUrl={club.avatar.replace("pic3.zhimg.com", "pic1.zhimg.com")}
          text={club.name}
        />
      ))}
    </header>
  );
};
