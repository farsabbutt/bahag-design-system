/**
 * This is a Card component
 */
export function MyCard({
  className,
  title,
  href,
}: {
  className?: string;
  title: string;
  href: string;
}): JSX.Element {
  return (
    <a
      className={className}
      href={`${href}?utm_source=create-turbo&utm_medium=basic&utm_campaign=create-turbo"`}
      rel="noopener noreferrer"
      target="_blank"
    >
      <h2>
        {title} <span>-&gt;</span>
      </h2>
      <p>No more children</p>
    </a>
  );
}
