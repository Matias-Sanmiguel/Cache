export function LoadingScreen({ label }: { label: string }) {
  return (
    <div style={{ minHeight: '100dvh', display: 'flex', alignItems: 'center', justifyContent: 'center', background: 'var(--ink)' }}>
      <div style={{ textAlign: 'center' }}>
        <div className="font-mono" style={{ fontSize: 10, color: 'var(--acid)', letterSpacing: '0.18em' }}>
          {label}
        </div>
        <div className="font-editorial-italic" style={{ fontSize: 16, color: 'var(--mute)', marginTop: 8 }}>
          cargando...
        </div>
      </div>
    </div>
  )
}
