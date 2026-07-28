local M = {
  AudioOnly = {
    Operations = {
      {
        PlayAudio = {
          VoiceName = "$Dialogue.VoiceName",
          OverrideAttachActor = "$TalkTaskData.AudioAttachActor",
          bIsAttachActor = "$IsValid($TalkTaskData.AudioAttachActor)"
        }
      }
    }
  },
  Boss = {
    Operations = {
      {
        SEQ = {
          [1] = {
            PrepareDialogue = {DialogueData = "$Dialogue"}
          },
          [2] = {
            PARA = {
              [1] = {
                Delay = {
                  Delay = "$Dialogue.Duration",
                  GroupTag = "$Owner"
                }
              },
              [2] = {
                PlayAudio = {
                  VoiceName = "$Dialogue.VoiceName",
                  ExtraInfo = "$RawDialogue",
                  SoundHandle = "$TalkTaskData.BasicTalkType",
                  OverrideAttachActor = "$TalkTaskData.AudioAttachActor",
                  bIsAttachActor = "$IsValid($TalkTaskData.AudioAttachActor)"
                }
              }
            }
          }
        }
      }
    }
  },
  Bubble = {
    DialogueDataType = "Bubble",
    Operations = {
      {
        SEQ = {
          [1] = {
            BubbleUI = {
              DialogueId = "$DialogueId",
              DialogueData = "$Dialogue"
            }
          },
          [2] = {
            PARA = {
              [1] = {
                Delay = {
                  Delay = "$Dialogue.Duration",
                  GroupTag = "$Owner"
                }
              },
              [2] = {
                PlayAudio = {
                  VoiceName = "$Dialogue.VoiceName",
                  SrcActor = "$Dialogue.TalkActorData.TalkActor",
                  ExtraInfo = "$RawDialogue",
                  SoundHandle = "$TalkTaskData.BasicTalkType",
                  bIsAttachActor = true
                }
              },
              [3] = {
                PlayScript = {
                  DialogueId = "$DialogueId"
                }
              }
            }
          }
        }
      }
    }
  },
  Observation = {
    Operations = {
      {
        SEQ = {
          [1] = {
            TypingText = {
              DialogueData = "$Dialogue",
              NameWidget = "$Owner.NpcNameText",
              TypingWidget = "$Owner.TypingText"
            }
          },
          [2] = {
            PlayScript = {
              DialogueId = "$DialogueId"
            }
          }
        }
      }
    }
  }
}
return M
