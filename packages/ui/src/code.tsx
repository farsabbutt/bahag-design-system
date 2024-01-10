export function Code({
  className,
  items
}: {
  className?: string;
  items: { title: string }[]
}): JSX.Element {
  return <code className={className}>
    {items.map((item) => (<li>{item.title}</li>))}
  </code>;
}
