import React from "react";
import useSWR from "swr";
import unfetch from "unfetch";

const Item = ({ iconUrl, text }) => {
  return (
    <a
      className="px-4 py-2 m-2 rounded-full hover:bg-blue-200 flex items-center"
      href="#"
    >
      <img
        className="flex-initial h-10 w-10 rounded-full inline"
        src={iconUrl}
      />
      {text && (
        <span
          className="ml-4 text-xl font-medium"
          style={{
            overflow: "hidden",
            textOverflow: "ellipsis",
            whiteSpace: "nowrap"
          }}
        >
          {text}
        </span>
      )}
    </a>
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
        text="个人资料"
      />
      {clubs.map(club => (
        <Item key={club.id} iconUrl={club.avatar} text={club.name} />
      ))}
    </header>
  );
};
