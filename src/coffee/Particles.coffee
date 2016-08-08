class Particles extends ParticleEngine
  init: (opts) ->
    opts = merge opts,
      width: 1
      height: 1
      initCount: 1000

    super opts
